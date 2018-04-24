export DEBIAN_FRONTEND=noninteractive
apt-get --yes install libpam-ldap nscd

debconf_url='https://raw.githubusercontent.com/codycodes/Linux_at_SCC_NTI/master/NTI310/lab_1/debconf'
wget --no-verbose -P /tmp/ $debconf_url

echo "Enter the internal ip address of your LDAP server: "
read internal_ip
sed -i.bak "\,ldap://,s,$,$internal_ip," /tmp/debconf # add internal ip to debconf

while read line; do echo "$line" | debconf-set-selections; done < /tmp/debconf # read each line as input to set debconf

apt-get --yes install libpam-ldap nscd # now that debconf is setup, get libpam

sed -i.bak '/compat/s/$/ ldap/' /etc/nsswitch.conf # sed line to append ldap w/"compat" match

systemctl reload nscd

# Check LDAP server for users
getent passwd

unset DEBIAN_FRONTEND
