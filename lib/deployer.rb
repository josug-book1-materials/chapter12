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
    File.open("#{ENV['CHEF_REPO_OPENSTACK_SAMPLE']}/cookbooks/openstack-sample/attributes/default.rb", "w") do |file|
        file.puts ERB.new(File.read("default.erb")).result(binding)
    end
    Open3.capture3('knife cookbook upload -a', :chdir => "#{ENV['CHEF_REPO_OPENSTACK_SAMPLE']}")
    puts 'cookbooks uploaded.'
    Open3.capture3('knife role from file roles/*.rb', :chdir => "#{ENV['CHEF_REPO_OPENSTACK_SAMPLE']}")
    puts 'roles uploaded.'
    Open3.capture3('knife environment from file environments/*.json', :chdir => "#{ENV['CHEF_REPO_OPENSTACK_SAMPLE']}")
    puts 'environments uploaded.'
  end

  def deploy
    tasks = []
    @servers.each do |server|
      tasks.push Thread.start { _deploy() }
    end
    tasks.each { |task| task.join }
  end

  private
  def _deploy(task)
    task = "knife zero bootstrap --no-host-key-verify #{server.ip_address} -N #{server.name} -r 'role[#{server.role}]' -x root -i #{server.key_file} -E #{server.provider}"
    logfile = "/tmp/#{server.name}_bootstrap.log 2>&1"
    Open3.capture3("#{task} > #{logfile}", :chdir => "#{ENV['CHEF_REPO_OPENSTACK_SAMPLE']}")
    puts "deploy finished => #{server.name}"
    puts "check logfile => more #{logfile}"
  end

  def servers_ok?
    i = 0
    @servers.each do |server|
      while true
        raise "ping retry limit " + max.to_s if i == 100
        if server.ip_address && Net::Ping::External.new(server.ip_address).ping?
          puts 'I found icmp session to :' + server.name
          break
        else
          puts 'waiting icmp session to :' + server.name
          sleep(6)
          i+=1
        end
      end
    end
  end
end

