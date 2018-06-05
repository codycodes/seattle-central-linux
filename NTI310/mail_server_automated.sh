#!/bin/bash

yum update
yum install epel-release
yum install -y exim mailx dovecot

#TODO:  Note that "wgeting" exim and dovecot config files is fine to complete the configuration.

mkdir /root/SSL/mail.nti310.com -p
cd /root/SSL/mail.nti310.com
#TODO: provide state, city, and so on in your arguments. ✔️
openssl req \
-nodes -x509 -days 365 -sha256 \
-subj '/C=US/ST=Washington/L=Seattle/O=Seattle Central College/CN=www.cody.codes' \
-newkey rsa:2048 -keyout mail.nti310.com.key -out mail.nti310.com.crt

cp mail.nti310.com.key mail.nti310.com.crt /etc/ssl/

cp /etc/exim/exim.conf{,.orig}

#TODO: do the online tutorial for exim ✔️

curl https://raw.githubusercontent.com/codycodes/Linux_at_SCC_NTI/master/NTI310/exim_configuration > /etc/exim/exim.conf

systemctl start exim && systemctl enable exim
systemctl status exim

# sdiff exim.conf exim.conf.orig

# TODO: replace with your user
# echo "test" | /usr/sbin/exim -v person@mydomain.com

tail /var/log/exim/main.log # follow the mail messages

# check to ensure it looks like the following

# 018-05-30 21:52:31 1fO91D-0000aA-5q == person@localhost R=localuser T=local_delivery def
# er (-1): maildir_format requires "directory" to be specified for the local_delivery transport
# 2018-05-30 21:52:46 1fO8xL-0000ZL-MH H=mail.mydomain.com [65.254.254.52] Connection timed out
# 2018-05-30 21:52:47 1fO8tF-0000XZ-UR H=mail.mydomain.com [65.254.254.53] Connection timed out
# 2018-05-30 21:53:03 1fO8xd-0000ZR-Ec H=mail.mydomain.com [65.254.254.51] Connection timed out
# 2018-05-30 21:54:53 1fO8xL-0000ZL-MH H=mail.mydomain.com [65.254.254.51] Connection timed out
# 2018-05-30 21:54:54 1fO8tF-0000XZ-UR H=mail.mydomain.com [65.254.254.54] Connection timed out
# 2018-05-30 21:54:54 1fO8tF-0000XZ-UR == person@mydomain.com R=dnslookup T=remote_smtp def
# er (110): Connection timed out
# 2018-05-30 21:55:11 1fO8xd-0000ZR-Ec H=mail.mydomain.com [65.254.254.54] Connection timed out

# TODO: finish dovecot config

systemctl start dovecot && systemctl enable dovecot
systemctl status dovecot
