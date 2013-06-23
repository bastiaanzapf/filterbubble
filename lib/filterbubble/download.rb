require 'net/http'

def get_response_with_redirect(uri)
  r = Net::HTTP.get_response(uri)
  k=0
  while r.code == "301" || r.code == "302"
    uri=URI.parse(r.header['location'])
    r = Net::HTTP.get_response(uri)      
    k=k+1
    if (k>5)
      throw Exception("HTTP Redirects exceeded")
    end
  end  
  r.body()
end

def http_get(link)
  uri=URI(URI::encode(link))
  content=get_response_with_redirect(uri)
  return content
end

