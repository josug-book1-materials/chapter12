name "lb"
description "LB role"
run_list "recipe[selinux::disabled]", "recipe[openstack-sample::lb]", "recipe[iptables::disabled]"

