name "rest"
description "REST role"
run_list "recipe[selinux::disabled]", "recipe[openstack-sample::rest]", "recipe[iptables::disabled]"
