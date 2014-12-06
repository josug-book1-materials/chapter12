#!/usr/bin/env ruby
require 'fog'
require 'yaml'

class Server
  def self.create_from_file(file)
    server_options = YAML.load_file(file)
    if server_options.class != Array
      server_options = [server_options]
    end
    servers = []
    server_options.each do |server_option|
      server = Server.new(server_option)
      server.create
      servers.push(server)
    end
    servers
  end

  attr_accessor :provider
  attr_accessor :name
  attr_accessor :flavor
  attr_accessor :image_id
  attr_accessor :key_name
  attr_accessor :key_file
  attr_accessor :availability_zone
  attr_accessor :network_id
  attr_accessor :security_groups
  attr_accessor :role
  attr_reader :ip_address

  def initialize(server_option = {})
    @provider = server_option["provider"].capitalize
    @name = server_option["name"]
    @flavor = server_option["flavor"]
    @image_id = server_option["image_id"]
    @key_name = server_option["key_name"]
    @key_file = server_option["key_file"]
    @availability_zone = server_option["availability_zone"]
    @network_id = server_option["network_id"]
    @security_groups = server_option["security_groups"] || []
    @role = server_option["role"]
    @ip_address = nil
    self.extend Module.const_get(@provider + "Api")
  end
end

module OpenstackApi
  def create
    api.servers.create(
      :name              => @name,
      :flavor_ref        => flavor_id,
      :image_ref         => @image_id,
      :key_name          => @key_name,
      :availability_zone => @availability_zone,
      :nics              => [{ "net_id" => @network_id }],
      :security_groups   => @security_groups
    )
  end

  def ip_address
    @ip_address ||= (address=api.servers.find { |s| s.name == @name }.addresses.shift) && address[1][0]['addr']
  end

  private
  def api
    Fog::Compute.new({
        :provider           => @provider,
        :openstack_auth_url => ENV['OS_AUTH_URL'] || "",
        :openstack_username => ENV['OS_USERNAME'] || "",
        :openstack_tenant   => ENV['OS_TENANT_NAME'] || "",
        :openstack_api_key  => ENV['OS_API_KEY'] || "",
        :openstack_region   => ENV['OS_REGION_NAME'] || ""
    })
  end

  def flavor_id
    api.flavors.find { |f| f.name == @flavor }.id
  end
end

module AwsApi
  def create
    api.servers.create(
      :tags => {'Name' => @name},
      :flavor_id => @flavor,
      :image_id => @image_id,
      :key_name => @key_name,
      :availablity_zone => @availability_zone,
      :subnet_id => @network_id,
      :security_group_ids => security_group_ids
    )
  end

  def ip_address
    @ip_address ||= api.servers.find { |s| s.tags['Name'] == @name && s.state != "terminated" }.private_ip_address
  end

  private
  def api
    Fog::Compute.new({
        :provider              => @provider,
        :aws_access_key_id     => ENV["AWS_ACCESS_KEY_ID"] || "",
        :aws_secret_access_key => ENV["AWS_SECRET_ACCESS_KEY"] || "",
        :region                => ENV["AWS_REGION"] || ""
    })
  end

  def security_group_ids
    @security_groups.map do |security_group| 
      api.security_groups.find { |sg| sg.name == security_group }.group_id 
    end
  end
end

