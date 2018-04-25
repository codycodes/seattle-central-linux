#!/bin/bash
yum --yes install cacti
yum --yes install mariadb-server
yum --yes install php-process php-gd php

systemctl enable mariadb && systemctl start mariadb
systemctl enable httpd && systemctl start httpd
systemctl enable snmpd && systemctl start snmpd

echo -n "Enter the password you'd like to use for MariaDB: "
read db_password
mysqladmin -u root password $db_password

mysql_tzinfo_to_sql /usr/share/zoneinfo | mysql -u root -p mysql

echo -n "Enter the password you'd like to use for cacti: "
read cacti_password

echo "create database cacti;
GRANT ALL ON cacti.* TO cacti@localhost IDENTIFIED BY '$cacti_password';
FLUSH privileges;

GRANT SELECT ON mysql.time_zone_name TO cacti@localhost;
flush privileges;" > cacti_auth.sql
mysql -u root -p < cacti_auth.sql

rpm -ql cacti | grep cacti.sql
mysql -u cacti -p cacti < /usr/share/doc/cacti-1.0.4/cacti.sql
vim /etc/cacti/db.php # manual editing here

/etc/httpd/conf.d/cacti.conf # more manual editing

systemctl reload httpd

sed -i.bak 's/#//g' /etc/cron.d/cacti # remove cron comments; bring cacti to life

sed -i.bak 's,SELINUX=enforcing,SELINUX=disabled,g' /etc/sysconfig/selinux # don't load an selinux policy on next boot
setenforce 0 # set selinux to permissive now
