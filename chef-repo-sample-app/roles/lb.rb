name "lb"
description "LB role"
run_list "recipe[selinux::disabled]", "recipe[sample-app::lb]", "recipe[iptables::disabled]"
default_attributes(
  "root_group" => "root"
)
