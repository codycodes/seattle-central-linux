#!/bin/bash
yum --yes install cacti
yum -yes install mariadb-server
yum -yes install php-process php-gd php
systemctl enable mariadb
systemctl enable httpd
systemctl enable snmpd

systemctl start mariadb
systemctl start httpd
systemctl start snmpd

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
flush privileges;" > stuff.sql


mysql -u root -p < stuff.sql
rpm -ql cacti | grep cacti.sql


mysql -u cacti -p cacti < /usr/share/doc/cacti-1.0.4/cacti.sql
vim /etc/cacti/db.php

/etc/httpd/conf.d/cacti.conf

systemctl reload httpd
sed -i.bak 's/#//g' /etc/cron.d/cacti
setenforce 0
