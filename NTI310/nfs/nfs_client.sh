#!/bin/bash
# nfs client automation script
apt-get install -y nfs-client
echo -n "Please enter your ip address: "
read ipaddress
showmount -e $ipaddress
mkdir /mnt/test
echo "$ipaddress:/var/nfsshare/testing        /mnt/test       nfs     defaults 0 0" >> /etc/fstab
mount -a
cd /mnt/test/
