name "rest"
description "REST role"
run_list "recipe[selinux::disabled]", "recipe[sample-app::rest]", "recipe[iptables::disabled]"
