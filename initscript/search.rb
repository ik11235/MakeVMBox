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
##http://localhost:3000/vmimages.json?&q%5Bosname_eq%5D=ubuntu&q%5Bosversion_eq%5D=8.04.4-server-i386
uri = URI.parse("http://localhost:3000/vmimages.json")
#&tag=nova,mysql,activemq
parameter = URI.escape("q[osname_eq]=#{OSname}&q[osversion_eq]=#{OSver}&tag=#{Tag}")
http = Net::HTTP.new(uri.host, uri.port)

response = nil
http.start {
  response = http.get(uri.path+"?"+parameter)
  # p response.body
}
data = JSON.parse(response.body)
#p data
data.each do |list|
  puts list["id"]
end
