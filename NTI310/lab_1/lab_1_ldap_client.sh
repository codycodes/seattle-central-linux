DEBIAN_FRONTEND=noninteractive
apt-get --yes install libpam-ldap nscd
# TODO: add debconf stuff


wget -P /tmp/ 
sed -i.bak "\;ldap://;s;$; $internal_ip_address;"  # add internal ip to debconf
sed -i.bak '/compat/s/$/ ldap/' /etc/nsswitch.conf # sed line to append ldap w/"compat" match
