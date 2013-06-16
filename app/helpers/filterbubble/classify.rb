# -*- coding: utf-8 -*-

require 'libxml' 
require '../app/helpers/filterbubble/crm.rb'
require '../app/helpers/filterbubble/download.rb'
require '../app/helpers/filterbubble/parse.rb'

meta_id=1;

items=Item.find(:all,:conditions => "meta_id IS NULL",
                :joins => ("LEFT JOIN categories_items ON "+
                           "(categories_items.item_id=item.item_id "+
                           "AND meta_id="+meta_id.to_s+") ")
                );

class ClassifyException < Exception
end

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
          doc=parse_html(html)
          @text=extract_xpath_text(doc,fmt.parameter)
          result=crm_classify(@text,meta_id)
          
          cat=Category.find(:first,:conditions => {"name" => result[0].to_s});
          
          puts item.link+" "+result[0].to_s

          File.open('../cache/'+(meta_id.to_s)+'/'+
                    (cat.category_id.to_s)+'/'+
                    (item.item_id.to_s),'w') { |file|
            file.write(@text);
            file.close();
          }

          if (result[1]<0.6)
            throw ClassifyException.exception("Konfidenz < 0.6 - gehört nicht in diese Kategorie")
          end
          
          ActiveRecord::Base.connection.execute('INSERT INTO categories_items '+
                                                '(item_id,meta_id,category_id,confidence)'+
                                                ' VALUES (%i,%i,%i,%f)'%
                                                [item.item_id,meta_id,
                                                 cat.category_id,result[1]]
                                                )
        end
      end
    end
  rescue IRB::Abort, SystemExit, Interrupt => e
    puts "Abgebrochen!"
    raise
  rescue Exception => e
    puts "Fehler: "+e.to_s+"\n"+e.backtrace.join("\n")
  end
end
