name "web"
description "Web role"
run_list "recipe[selinux::disabled]", "recipe[openstack-sample::web]", "recipe[iptables::disabled]"
