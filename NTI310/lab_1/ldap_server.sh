#!/bin/bash

yum install git -y
git clone https://github.com/nic-instruction/hello-nti-310.git /tmp # clone to /tmp folder

yum -y install openldap-servers openldap-clients

unalias cp # unalias to ensure that we remove interactive mode

cp /usr/share/openldap-servers/DB_CONFIG.example /var/lib/ldap/DB_CONFIG # Add example DB_CONFIG
chown ldap . /var/lib/ldap/DB_CONFIG # chown for user and group

systemctl enable slapd && systemctl start slapd

yum -y install httpd epel-release phpldapadmin # install components for LDAP web interface
setbool -P httpd_can_connect_ldap on # selinux permissions for HTTPD and LDAP

systemctl enable httpd && systemctl start httpd

sed -i 's,Require local,#Require local\n   Require all granted,g' /etc/httpd/conf.d/phpldapadmin.conf # allow host access from any IP

cp /tmp/hello-nti-310/config/config.php /etc/phpldapadmin/config.php # get the new config.php for ldap admin from the github repo
chown ldap:apache /etc/phpldapadmin/config.php

# setup password/hash for ldap
newsecret=$(slappasswd -g)
newhash=$(slappasswd -s "$newsecret")
echo -n "$newsecret" > /root/ldap_admin_pass
chmod 0600 /root/ldap_admin_pass # give owner r/w permissions

# Add boilerplate databases
ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/openldap/schema/cosine.ldif
ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/openldap/schema/nis.ldif
ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/openldap/schema/inetorgperson.ldif

echo -e "dn: olcDatabase={2}hdb,cn=config
changetype: modify
replace: olcSuffix
olcSuffix: dc=nti310,dc=local
\n
dn: olcDatabase={2}hdb,cn=config
changetype: modify
replace: olcRootDN
olcRootDN: cn=ldapadm,dc=nti310,dc=local
\n
dn: olcDatabase={2}hdb,cn=config
changetype: modify
replace: olcRootPW
olcRootPW: $newhash" > /tmp/db.ldif

echo 'dn: olcDatabase={1}monitor,cn=config
changetype: modify
replace: olcAccess
olcAccess: {0}to * by dn.base="gidNumber=0+uidNumber=0,cn=peercred,cn=external, cn=auth"' \
'read by dn.base="cn=ldapadm,dc=nti310,dc=local" read by * none' > /tmp/monitor.ldif

openssl req -new -x509 -nodes -out /etc/openldap/certs/nti310ldapcert.pem -keyout /etc/openldap/certs/nti310ldapkey.pem -days 365 \
-subj "/C=US/ST=WA/L=Seattle/O=SCC/OU=IT/CN=nti310.local"
chown -R ldap. /etc/openldap/certs/nti310ldapkey.pem

echo -e "dn: cn=config
changetype: modify
replace: olcTLSCertificateFile
olcTLSCertificateFile: /etc/openldap/certs/nti310ldapcert.pem
\n
dn: cn=config
changetype: modify
replace: olcTLSCertificateKeyFile
olcTLSCertificateKeyFile: /etc/openldap/certs/nti310ldapkey.pem" > /tmp/certs.ldif

ldapmodify -Y EXTERNAL -H ldapi:/// -f /tmp/db.ldif
ldapmodify -Y EXTERNAL -H ldapi:/// -f /tmp/monitor.ldif
ldapmodify -Y EXTERNAL -H ldapi:/// -f /tmp/certs.ldif

slaptest -u # run a slaptest to verify configuration

# Creates group and people structure base
echo -e "dn: dc=nti310,dc=local
dc: nti310
objectClass: top
objectClass: domain
\n
dn: cn=ldapadm ,dc=nti310,dc=local
objectClass: organizationalRole
cn: ldapadm
description: LDAP Manager
\n
dn: ou=People,dc=nti310,dc=local
objectClass: organizationalUnit
ou: People
\n
dn: ou=Group,dc=nti310,dc=local
objectClass: organizationalUnit
ou: Group" > /tmp/base.ldif

setenforce 0 # selinux permissive mode

ldapadd -x -W -D "cn=ldapadm,dc=nti310,dc=local" -f /tmp/base.ldif -y /root/ldap_admin_pass

alias cp='cp -i' # re-alias so it works the way that it did before

systemctl reload httpd
