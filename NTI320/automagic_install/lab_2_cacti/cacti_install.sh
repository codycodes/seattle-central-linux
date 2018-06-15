#!/bin/bash
yum -y install cacti
yum -y install mariadb-server
yum -y install php-process php-gd php

systemctl enable mariadb && systemctl start mariadb
systemctl enable httpd && systemctl start httpd
systemctl enable snmpd && systemctl start snmpd

echo -n "Enter the password you'd like to use for MariaDB: "
# read db_password
# mysqladmin password "$db_password" # set the mysql database password
db_password="P@ssw0rd1"

# echo -n "Enter the password you'd like to use for cacti: "
# read cacti_password
cacti_password="P@ssw0rd1"

mysql -u root password $db_password

echo "create database cacti;
GRANT ALL ON cacti.* TO cacti@localhost IDENTIFIED BY '$cacti_password';
FLUSH privileges;

GRANT SELECT ON mysql.time_zone_name TO cacti@localhost;
flush privileges;" > cacti_auth.sql
mysql -p"$db_password" -u root < cacti_auth.sql # insert this sql into the db

# add tzinfo to mysql db
mysql_tzinfo_to_sql /usr/share/zoneinfo | mysql -p"$db_password" --database=mysql

cacti_path=$(rpm -ql cacti | grep cacti.sql) # grabs the path to cacti

mysql cacti < $cacti_path -u cacti -p"$cacti_password"

sed -i.bak "s,\$database_username = 'cactiuser',\$database_username = 'cacti',g" /etc/cacti/db.php
sed -i "s,\$database_password = 'cactiuser',\$database_password = '$cacti_password',g" /etc/cacti/db.php

sed -i 's/Require host localhost/Require all granted/g' /etc/httpd/conf.d/cacti.conf
sed -i 's/Allow from localhost/Allow from all/g' /etc/httpd/conf.d/cacti.conf
systemctl reload httpd
sed -i.bak 's/#//g' /etc/cron.d/cacti # remove cron comments; bring cacti to life

# update php.ini
sed -i.bak ''

sed -i 's,SELINUX=enforcing,SELINUX=disabled,g' /etc/sysconfig/selinux # don't load an selinux policy on next boot
setenforce 0 # set selinux to permissive now

echo "[nti-320]
name=Extra Packages for Centos from NTI-320 7
# Note, this is putting repodata at packages instead of 7 and our path is a hack around that.
baseurl=http://repo_internal_ip/centos/7/extras/x86_64/Packages/
enabled=1
gpgcheck=0
" >> /etc/yum.repos.d/NTI-320.repo

echo "*.info;mail.none;authpriv.none;cron.none   @syslog_internal_ip$" >> /etc/rsyslog.conf && systemctl restart rsyslog.service
