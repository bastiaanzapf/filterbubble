require 'libxml' 
require './database'
require 'net/http'
require 'crm114'

feed=2

items=@db.exec('SELECT feed_id,link FROM item WHERE feed_id=$1 OFFSET 4 LIMIT 1',[feed])
formats=@db.exec('SELECT format_id,algorithm,parameter FROM format WHERE feed_id=$1',[feed])
metas=@db.exec('SELECT meta_id FROM meta')

def classify_crm(text,meta_id)
  Dir.chdir('crm/'+meta_id.to_s+'/')

  categories=@db.exec('SELECT name FROM category WHERE meta_id=$1',[meta_id])
  syms=categories.map{|a| a["name"].to_sym();}
  print syms
  print "\n"
  crm = Classifier::CRM114.new(syms)
  print crm.classify(text)
  Dir.chdir('../../');
end

items.each do |item|
  print item['link']
  uri=URI(item['link'])
  content=Net::HTTP.get(uri)

  options=
    LibXML::XML::HTMLParser::Options::NOBLANKS |
    LibXML::XML::HTMLParser::Options::NOERROR |
    LibXML::XML::HTMLParser::Options::NONET |
    LibXML::XML::HTMLParser::Options::NOWARNING |
    LibXML::XML::HTMLParser::Options::RECOVER;

  parser=LibXML::XML::HTMLParser.string(content,
                                        :options=>options)
  doc=parser.parse
  
  formats.each do |format|
    case format['algorithm']
    when 'xpath'
      texts=doc.find(format['parameter'])
      print format['parameter']+"\n";
      text=""
      texts.each do |t|
        text+=t.content+" "
      end
#      print text
      classify_crm(text,1)

    else
      print "Unknown algorithm in format "+format['format_id']+
        ": "+format['algorithm']
    end    
  end 
  die();
end
