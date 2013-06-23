require 'libxml' 
require './database'

feed=2

feed=@db.exec('SELECT feed_id,url FROM feed WHERE feed_id=$1',[feed])

insert='INSERT INTO item (feed_id,link) VALUES ($1,$2)'
insert_link=@db.prepare('insert_link',insert)
                        
feed.each do |feedrow|
  url=feedrow['url']

  parser=LibXML::XML::Parser.file(url)
  doc=parser.parse

  links=doc.find('//item/link')

  links.each do |link|
    feed_id=feedrow['feed_id']
    begin
      @db.exec_prepared('insert_link',[feed_id,link.content])
      print link.content
      print " - akzeptiert.\n"
    rescue PGError => e
    end
  end
end
