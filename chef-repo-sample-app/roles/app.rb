name "app"
description "APP role"
run_list "recipe[selinux::disabled]", "recipe[sample-app::app]", "recipe[iptables::disabled]"
