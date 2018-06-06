#!/bin/bash
# nfs client automation script
apt-get install -y nfs-client
mkdir /mnt/test
echo "nfs_server_ip:/var/nfsshare/testing        /mnt/test       nfs     defaults 0 0" >> /etc/fstab
mount -a
cd /mnt/test/
