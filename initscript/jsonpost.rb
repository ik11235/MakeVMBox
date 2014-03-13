require 'net/https'
require 'json'

if ARGV.size < 2 
  puts "input data size error";
  exit
end

OSname=ARGV[0]
OSver=ARGV[1]
Tag="";
if ARGV.size > 2
  for i in 2..(ARGV.size)-1 do
    if Tag == ""
      Tag=ARGV[i]
    else
      Tag+=","+ARGV[i]
    end
  end
end
uri = URI.parse("http://localhost:3000/vmimages.json")
response = nil
request = Net::HTTP::Post.new(uri.request_uri, initheader = {'Content-Type' =>'application/json'})
request.body ={vmimage:{osname:OSname,osversion:OSver,tag_list:Tag}}.to_json

http = Net::HTTP.new(uri.host, uri.port)

http.start do |h|
  response = h.request(request)
end
