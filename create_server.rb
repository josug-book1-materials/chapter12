$:.unshift File.dirname(__FILE__)
require 'lib/server.rb'

servers = Server.create_from_file(ARGV[0])
servers.each do |server| 
  while true
    if server.ip_address.nil?
       sleep(5)
    else
      puts server.to_yaml.sub(/^\-\-\- \|\n/,"").sub(/^ *--- !ruby\/object:.*\n/,"").sub(/^ */," - ").gsub(/\n/,"\n   ").gsub(/^ *$/,"")
      break
    end
  end
end
