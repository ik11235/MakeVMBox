# -*- coding: utf-8 -*-

require 'net/https'
require 'json'

i=1;
cnt=1;

##URIパラメータが正しく渡っていない？
while cnt!=0
  uri = URI.parse("https://api.github.com/users/opscode-cookbooks/repos")
  puts "https://api.github.com/users/opscode-cookbooks/repos?page="+i.to_s;
  parameter="page="+i.to_s
  http = Net::HTTP.new uri.host, uri.port
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE
  
  body="";
  http.start {
    response = http.get(uri.path+"?"+parameter)
    body+=response.body
  }
#  puts body
  
  json = JSON.parser.new(body)
  
  #parse()メソッドでハッシュ生成
  hash =  json.parse()
  #puts hash
  cnt=0
  hash.each do |list|
    puts list["name"]
    cnt+=1
  end
  i+=1
  
end
