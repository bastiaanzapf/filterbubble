# -*- coding: utf-8 -*-

require 'libxml' 
require 'crm.rb'
require 'download.rb'
require 'parse.rb'

#metas=[1,2];

meta_id=1;

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
          html=http_get(item.link)
          if (html.bytesize<100)
            throw ClassifyException.exception("Body almost empty")
          end
          if (html!="")
            puts fmt.parameter

            metas.each do |meta|

              meta_id=meta.meta_id

              classfied=Category.
                find(:first,
                     :joins => 'JOIN categories_items USING (meta_id)',
                     :conditions =>
                     {"meta_id" => meta_id})

              if (!defined?(classified))

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
      end
    rescue SystemExit, Interrupt => e
      puts "Abgebrochen!"
      raise
    rescue Exception => e
      puts "Fehler: "+e.to_s+"\n"+e.backtrace.join("\n")
    end
  end
end
