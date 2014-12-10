#!/bin/bash

WORK_DIR=$HOME/work_chapter

get_uuid () { cat - | grep " id " | awk '{print $4}'; }

for server in `nova list | grep " fog-server " | awk '{print $2}'`; do
  nova delete $server
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
done

for fip in `nova floating-ip-list | awk '{if ($6 == "-") print $2;}'`; do
  nova floating-ip-delete $fip
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

#MY_FOG_NET=`neutron net-show fog-net | get_uuid`
#FIP=`nova floating-ip-create | awk '{if ($6 == "-") print $2}'`
#nova floating-ip-associate fog-server $FIP
