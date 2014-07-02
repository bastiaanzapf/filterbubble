require 'net/http'

def get_response_with_redirect(uri)
  r = Net::HTTP.get_response(uri)
  k=0
  while r.code == "301" || r.code == "302"
    nuri=URI.parse(r.header['location'])
    print nuri.to_s+"\n"
    if (nuri.absolute?)
      uri=nuri
      print "Absolute Redirect to:" + uri.to_s + "\n"
    else
      uri.path=nuri.path
      uri.query=nuri.query
      uri.fragment=nuri.fragment
      print "Relative Redirect to: "+uri.to_s+"\n"
    end
    r = Net::HTTP.get_response(uri)      
    k=k+1
    if (k>5)
      raise "HTTP Redirects exceeded"
    end
  end  
  r.body()
end

def http_get(link)
  uri=URI(URI::encode(link))
  content=get_response_with_redirect(uri)
  return content
end

