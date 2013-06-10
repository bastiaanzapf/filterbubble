require 'net/http'

def http_get(link)
  uri=URI(link)
  content=Net::HTTP.get(uri)
  return content
end

