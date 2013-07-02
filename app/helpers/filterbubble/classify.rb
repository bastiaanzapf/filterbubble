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

  items=Item.find(:all,:conditions => "created_at > now()- interval '1 day' ")

  items.each do |item|
    begin
      fmt=item.feed.format[0]
      if (fmt)
        if (fmt.parameter)          
          metas.each do |meta|

            meta_id=meta.meta_id
            
            classified=item.category.
              find(:first,
                   :joins => 'JOIN categories_items USING (meta_id)',
                   :conditions =>
                   {"meta_id" => meta_id})
            
            if (!defined?(classified))
              
              html=http_get(item.link)
              
              if (html.bytesize<200)
                throw ClassifyException.exception("Body almost empty")
              end
              
              doc=parse_html(html)
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
    rescue Exception => e
      puts "Fehler: "+e.to_s+"\n"+e.backtrace.join("\n")
      raise
    end
  end
end
