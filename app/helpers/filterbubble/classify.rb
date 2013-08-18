# -*- coding: utf-8 -*-

require 'libxml' 
require 'helpers/filterbubble/crm'
require 'helpers/filterbubble/download'
require 'helpers/filterbubble/parse'
require 'irb'
#metas=[1,2];

#meta_id=1;

class ClassifyException < Exception
end

def classify_all

  metas=Meta.find(:all)

  items=Item.find(:all,
                  :joins => [:feed],
                  :conditions => "active='t' AND created_at > now()- interval '1 day' ")

  items.each do |item|
    begin

      fmt=item.feed.format[0]
      if (fmt) # can't classify without format
        if (fmt.parameter)          
          
          # forget previous content
          
          html=nil
          doc=nil

          metas.each do |meta|
            
            meta_id=meta.meta_id
            
            classified=item.category.
              find(:first,
                   :conditions =>
                   {"meta_id" => meta_id})
            
            
            if (classified.nil?)
              
              if (html.nil?)
                
                # get content
                
                html=http_get(item.link)
                
                if (html.bytesize<200)
                  throw ClassifyException.exception("Body almost empty")
                end
                doc=parse_html(html)

              end

              if (doc.nil?)
                throw ClassifyException.exception("Could not parse HTML? Item "+item.item_id.to_s)
              end

              # extract title

              h1=extract_xpath_text(doc,'//h1[1]/descendant-or-self::text()[not(parent::script)]')
              puts "H1: "+h1
              
              if (h1)
                Title.create(:item_id =>item.item_id,
                             :title => h1)
              else
                h2=extract_xpath_text(doc,'//h2[1]/descendant-or-self::text()[not(parent::script)]')
                puts "H1: "+h1
              
                if (h2)
                  Title.create(:item_id =>item.item_id,
                               :title => h1)
                end

              end
              

              # extract text

              @text=extract_xpath_text(doc,fmt.parameter)
              
              result=crm_classify(@text,meta_id)
              
              cat=Category.find(:first,:conditions => 
                                {"meta_id" => meta_id,
                                  "name" => result[0].to_s});
              
              puts item.link+" "+result[0].to_s
              
              File.open('../cache/'+(meta_id.to_s)+'/'+
                        (cat.category_id.to_s)+'/'+
                        (item.item_id.to_s),'w') { |file|
                file.write(@text);
                file.close();
              }
              
              #          if (result[1]<0.6)
              #            throw ClassifyException.exception("Konfidenz < 0.6 - gehört nicht in diese Kategorie")
              #          end
              
              ActiveRecord::Base.connection.execute('INSERT INTO categories_items '+
                                                    '(item_id,meta_id,category_id,confidence)'+
                                                    ' VALUES (%i,%i,%i,%f)'%
                                                    [item.item_id,meta_id,
                                                     cat.category_id,result[1]]
                                                    )
            end
          end
        end
      end
    rescue IRB::Abort, SystemExit, Interrupt => e
      puts "Abgebrochen!"
      raise
    rescue URI::InvalidURIError => e
      puts "Ungültige URI."
    rescue EOFError => e
      puts "EOF?!"
    rescue Exception => e
      puts "Fehler: "+e.message
      puts e.backtrace.join("\n")
    end
  end
  return nil
end
