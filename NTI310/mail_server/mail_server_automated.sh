#!/bin/bash

yum update
yum install -y epel-release
yum install -y exim mailx dovecot

mkdir /root/SSL/mail.nti310.com -p
cd /root/SSL/mail.nti310.com

openssl req \
-nodes -x509 -days 365 -sha256 \
-subj '/C=US/ST=Washington/L=Seattle/O=Seattle Central College/CN=www.cody.codes' \
-newkey rsa:2048 -keyout mail.nti310.com.key -out mail.nti310.com.crt

cp mail.nti310.com.key mail.nti310.com.crt /etc/ssl/

cp /etc/exim/exim.conf{,.orig} # create a backup of the file (not a directory) exim.conf
mkdir $HOME/MailDir
curl "https://raw.githubusercontent.com/codycodes/Linux_at_SCC_NTI/master/NTI310/mail_server/exim_configuration" > /etc/exim/exim.conf

systemctl start exim && systemctl enable exim
systemctl status exim

useradd -m test
echo 'test:test' | chpasswd # add password of "test" to user test

echo "test" | /usr/sbin/exim -v test@nti310.com # locally test for mail delivery
echo "test" | /usr/sbin/exim -v test@gmail.com # test remote mail delivery which should fail

tail /var/log/exim/main.log # follow the mail messages

# check to ensure it looks similar to the following...

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

cp -r /etc/dovecot/conf.d{,.orig} # recursively create a backup of the directory
curl "https://raw.githubusercontent.com/codycodes/Linux_at_SCC_NTI/master/NTI310/mail_server/dovecot_ssl_config" > /etc/dovecot/conf.d/10-ssl.conf
curl "https://raw.githubusercontent.com/codycodes/Linux_at_SCC_NTI/master/NTI310/mail_server/dovecot_auth_config" > /etc/dovecot/conf.d/10-auth.conf
curl "https://raw.githubusercontent.com/codycodes/Linux_at_SCC_NTI/master/NTI310/mail_server/dovecot_mail_config" > /etc/dovecot/conf.d/10-mail.conf
curl "https://raw.githubusercontent.com/codycodes/Linux_at_SCC_NTI/master/NTI310/mail_server/dovecot_master_config" > /etc/dovecot/conf.d/10-master.conf

systemctl start dovecot && systemctl enable dovecot
systemctl status dovecot
