require 'lib/server'
require 'lib/deployer'

servers = Server.create_from_file(ARGV[0])
Deployer.new(servers).deploy()
