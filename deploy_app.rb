$:.unshift File.dirname(__FILE__)
require 'lib/server'
require 'lib/deployer'

ENV['CHEF_REPO'] = ENV['HOME'] + "/chapter12/chef-repo-sample-app"
ENV['COOKBOOK'] = "sample-app"

servers = Server.create_from_file(ARGV[0])
Deployer.new(servers).deploy()
