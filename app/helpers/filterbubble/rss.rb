require 'libxml' 

#feed=@db.exec('SELECT feed_id,url FROM feed WHERE feed_id=$1',[feed])


def get_feeds
  feed=Feed.find(:all)
  
  feed.each do |feedrow|
    url=feedrow.url

    begin
      parser=LibXML::XML::Parser.file(url)
      doc=parser.parse
      
      links=doc.find('//item/link')
      
      links.each do |link|
        begin
          if (!Item.find(:first, :conditions => { "link" => link.content }))
            Item.create(:feed_id => feedrow.feed_id, 
                        :link => link.content)
            print link.content
            puts " - akzeptiert."
          end
        end
      end
    rescue PGError => e
      puts "Postgres Error "+e.to_s
    rescue LibXML::XML::Error => e
      puts "XML Error "+e.to_s
    end    
  end
end
