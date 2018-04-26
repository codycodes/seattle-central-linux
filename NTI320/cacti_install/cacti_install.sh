#!/bin/bash
yum -y install cacti
yum -y install mariadb-server
yum -y install php-process php-gd php

systemctl enable mariadb && systemctl start mariadb
systemctl enable httpd && systemctl start httpd
systemctl enable snmpd && systemctl start snmpd

echo -n "Enter the password you'd like to use for MariaDB: "
read db_password
mysqladmin -u root --password=$db_password

mysql_tzinfo_to_sql /usr/share/zoneinfo | mysql -u root -p mysql

echo -n "Enter the password you'd like to use for cacti: "
read cacti_password

# TODO: Make custom username
# echo -n "If you'd like to change the default user from 'cactiuser' to your own user, \
# please input one now. Otherwise leave this field blank: "
# read cacti_username

echo "create database cacti;
GRANT ALL ON cacti.* TO cacti@localhost IDENTIFIED BY '$cacti_password';
FLUSH privileges;

GRANT SELECT ON mysql.time_zone_name TO cacti@localhost;
flush privileges;" > cacti_auth.sql
mysql -u root -p < cacti_auth.sql

cacti_path=$(rpm -ql cacti | grep cacti.sql) # grabs the path to cacti
mysql -u cacti -p cacti < /usr/share/doc/cacti-1.1.37/cacti.sql


# # update username and password fields inside cacti/db.php config
# if [ -z "$cacti_username" ]; then
#     echo "No username supplied, using default 'cactiuser'"
# else
#     echo "Adding user: $cacti_username"
#     sed -i.bak "s,\$database_username = cactiuser,\$database_username = $cacti_username,g" /etc/cacti/db.php
# fi
sed -i.bak "s,\$database_username = cactiuser,\$database_username = cacti,g" /etc/cacti/db.php
sed -i.bak "s,\$database_password = cactiuser,\$database_password = $cacti_password,g" /etc/cacti/db.php

sed -i 's/Require host localhost/Require all granted/g' /etc/httpd/conf.d/cacti.conf
sed -i 's/Allow from localhost/Allow from all/g' /etc/httpd/conf.d/cacti.conf
systemctl reload httpd
sed -i.bak 's/#//g' /etc/cron.d/cacti # remove cron comments; bring cacti to life

sed -i 's,SELINUX=enforcing,SELINUX=disabled,g' /etc/sysconfig/selinux # don't load an selinux policy on next boot
setenforce 0 # set selinux to permissive now
