require 'libxml' 

def parse_html(html)
  options=
    LibXML::XML::HTMLParser::Options::NOBLANKS |
    LibXML::XML::HTMLParser::Options::NOERROR |
    LibXML::XML::HTMLParser::Options::NONET |
    LibXML::XML::HTMLParser::Options::NOWARNING |
    LibXML::XML::HTMLParser::Options::RECOVER;

  parser=LibXML::XML::HTMLParser.string(html,
                                        :options=>options)
  doc=parser.parse
  
  return doc

end

def extract_xpath_text(doc,xpath)
  texts=doc.find(xpath)
  text=""
  texts.each do |t|
    text+=t.content+" "
  end
  return text
end
