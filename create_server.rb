$:.unshift File.dirname(__FILE__)
require 'lib/server.rb'
require 'lib/helper.rb'

servers = Server.create_from_file(ARGV[0])
servers.each do |server| 
  while true
    if server.ip_address.nil?
       sleep(5)
    else
      print_out server.to_yaml
      break
    end
  end
end
