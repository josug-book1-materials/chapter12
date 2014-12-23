#!/bin/bash

WORK_DIR=$HOME/work_chapter

get_uuid () { cat - | grep " id " | awk '{print $4}'; }

# Retrieve assigned IP addresses to release a floating IP
addrs=`nova show fog-server | grep fog-net | cut -d '|' -f 3 | sed -e 's/  *//g'`

for server in `nova list | grep " fog-server " | awk '{print $2}'`; do
  nova delete $server
  echo "Deleted fog-server ($server)"
done
while true; do
  nova list | grep -q " fog-server "
  if [ $? -ne 0 ]; then
    break
  fi
done

for subnet in `neutron subnet-list | grep " fog-subnet " | awk '{print $2}'`; do
  neutron router-interface-delete Ext-Router $subnet
done
for net in `neutron net-list | grep " fog-net " | awk '{print $2}'`; do
  neutron net-delete $net
done
for sg in `neutron security-group-list | grep " sg-for-fog " | awk '{print $2}'`; do
  neutron security-group-delete $sg
done
for key in `nova keypair-list | grep key-openstack | awk '{print $2}'`; do
  nova keypair-delete key-openstack
  echo "Deleted keypair key-openstack"
done

for fip in `nova floating-ip-list | awk -F '|' '{print $2,$4}' | awk '{if ($2 == "-") print $1;}'`; do
  for addr in ${addrs//,/ }; do
    if [ "$fip" = "$addr" ]; then
      nova floating-ip-delete $fip
      echo "Deleted floating IP $fip"
    fi
  done
done

echo "### keypair"
nova keypair-list
echo "### servers"
nova list
echo "### network"
neutron net-list
neutron subnet-list
echo "### security group"
neutron security-group-list
echo "### floating IP"
nova floating-ip-list
