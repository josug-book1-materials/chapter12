name "web"
description "Web role"
run_list "recipe[selinux::disabled]", "recipe[sample-app::web]", "recipe[iptables::disabled]"
