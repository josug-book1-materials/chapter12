name "db"
description "DB role"
run_list "recipe[selinux::disabled]", "recipe[mysql::server]", "recipe[openstack-sample::db]", "recipe[iptables::disabled]"
default_attributes(
  "mysql" => {
    "server_root_password" => "password",
    "allow_remote_root" => true,
    "host" => "localhost"
  }
)

