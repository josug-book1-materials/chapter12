#!/usr/bin/env ruby
require 'erb'
require 'open3'
require 'net/ping'

class Deployer
  attr_accessor :servers

  def initialize(servers)
    @servers = servers
    setup()
  end

  def setup
    servers_ok?
    File.open("#{ENV['CHEF_REPO']}/cookbooks/#{ENV['COOKBOOK']}/attributes/role_hosts.rb", "w") do |file|
      file.puts ERB.new(File.read("etc/role_hosts.erb"), nil, '-').result(binding)
    end
    Open3.capture3('knife cookbook upload -a -z', :chdir => "#{ENV['CHEF_REPO']}")
    puts 'cookbooks uploaded.'
    Open3.capture3('knife role from file roles/*.rb -z', :chdir => "#{ENV['CHEF_REPO']}")
    puts 'roles uploaded.'
  end

  def deploy
    @servers.each { |server| _deploy_server(server) } 
  end

  private
  def _deploy_server(server)
    task = "knife zero bootstrap --no-host-key-verify #{server.ip_address} -N #{server.name} -r 'role[#{server.role}]' -x root -i #{server.key_file}"
    logfile = "/tmp/#{server.name}_bootstrap.log"
    Open3.capture3("#{task} > #{logfile} 2>&1", :chdir => "#{ENV['CHEF_REPO']}")
    puts "deploy finished => #{server.name}"
    puts "check logfile => more #{logfile}"
  end

  def servers_ok?
    i = 0
    @servers.each do |server|
      while true
        raise "ping retry limit " + max.to_s if i == 100
        if server.ip_address && Net::Ping::External.new(server.ip_address).ping?
          puts 'I found icmp session to ' + server.name
          break
        else
          puts 'waiting icmp session to ' + server.name
          sleep(6)
          i+=1
        end
      end
    end
  end
end
