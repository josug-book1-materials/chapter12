#!/bin/bash

if nova list | grep fog-server; then
  echo "fog-server already exists."
  exit 1
fi

WORK_DIR=$HOME/work_chapter

get_uuid () { cat - | grep " id " | awk '{print $4}'; }

mkdir -p $WORK_DIR
nova keypair-add key-openstack | tee $WORK_DIR/key-openstack.pem
chmod 600 $WORK_DIR/key-openstack.pem

neutron net-create fog-net
neutron subnet-create --name fog-subnet fog-net 192.168.1.0/24
neutron router-interface-add Ext-Router fog-subnet

neutron security-group-create sg-for-fog
neutron security-group-rule-create --protocol tcp \
  --port-range-min 22 --port-range-max 22 \
  --remote-ip-prefix 0.0.0.0/0 \
  sg-for-fog
neutron security-group-rule-create --protocol icmp \
  --remote-ip-prefix 0.0.0.0/0 \
  sg-for-fog
neutron security-group-rule-create --protocol icmp \
  --remote-ip-prefix 192.168.1.0/24 \
  sg-for-fog
neutron security-group-rule-create --protocol tcp \
  --remote-ip-prefix 192.168.1.0/24 \
  sg-for-fog

MY_FOG_NET=`neutron net-show fog-net | get_uuid`
nova boot \
  --image centos-base \
  --key-name key-openstack \
  --flavor standard.medium \
  --nic net-id=$MY_FOG_NET \
  --security-groups sg-for-fog \
  --availability-zone az1 \
  fog-server

TIMEOUT=120
INTERVAL=5
MAX_LOOP=`expr 120 / 5`
for i in `seq 0 $MAX_LOOP`; do
  nova list | grep fog-server | grep ACTIVE >/dev/null
  if [ $? -eq 0 ]; then
    break
  fi
  if [ $i -eq $MAX_LOOP ]; then
    echo "fog-server does not become ACTIVE in $TIMEOUT seconds"
    exit 1
  fi
  sleep $INTERVAL
done

FIP=`nova floating-ip-create Ext-Net | awk -F '|' '{print $2,$4}' | awk '{if ($2 == "-") print $1;}'`
nova floating-ip-associate fog-server $FIP

echo "### fog-server ($FIP) is launched."
