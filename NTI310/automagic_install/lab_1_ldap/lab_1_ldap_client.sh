#!/bin/bash
debconf_url='https://raw.githubusercontent.com/codycodes/Linux_at_SCC_NTI/master/NTI310/automagic_install/lab_1_ldap/debconf'
wget --no-verbose -P /tmp/ $debconf_url
sed -i.bak "\,ldap://,s,$,ldap_server_ip," /tmp/debconf # add internal ip to debconf
while read line; do echo "$line" | debconf-set-selections; done < /tmp/debconf # read each line as input to set debconf

export DEBIAN_FRONTEND=noninteractive
apt-get --yes install libpam-ldap nscd
unset DEBIAN_FRONTEND

sed -i.bak '/compat/s/$/ ldap/' /etc/nsswitch.conf # sed line to append ldap w/"compat" match
systemctl reload-or-restart nscd

# verify that the client is working by seeing if my user is on the ldap-a server
getent passwd | grep cgagnon
