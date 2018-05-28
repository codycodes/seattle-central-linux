#!/bin/bash

# set variables first (faster)
echo "Please enter your new database password (also used as 'postgres' users' password for phpPgAdmin):"
read db_password

# contains the extra packages that we need
yum install -y epel-release
# postgres components
yum install -y python-pip python-devel gcc postgresql-server postgresql-devel postgresql-contrib
# install the web frontend
yum -y install phpPgAdmin

postgresql-setup initdb

# start postgresql now and start it at boot
systemctl start postgresql && systemctl enable postgresql

echo "CREATE DATABASE myproject;
CREATE USER myprojectuser WITH PASSWORD '$db_password';
ALTER ROLE myprojectuser SET client_encoding TO 'utf8';
ALTER ROLE myprojectuser SET default_transaction_isolation TO 'read committed';
ALTER ROLE myprojectuser SET timezone TO 'UTC';
GRANT ALL PRIVILEGES ON DATABASE myproject TO myprojectuser;" > /tmp/myproject.sql
# used in our script to input our newly coded db (above) as the postgres user
sudo -i -u postgres psql -U postgres -f /tmp/myproject.sql
rm -f /tmp/myproject.sql

# add postgres password, which is $db_password
echo "ALTER USER postgres WITH PASSWORD '$db_password';" > /tmp/postgres_user.sql
sudo -i -u postgres psql -U postgres -f /tmp/postgres_user.sql
rm -f /tmp/postgres_user.sql

# allow host access from any IP
sed -i.bak 's,Require local,Require all granted,g' /etc/httpd/conf.d/phpPgAdmin.conf

# disable extra login security for web access
sed -i "s,\$conf\['extra_login_security'\] = true;,\$conf\['extra_login_security'\] = false;,g" /etc/phpPgAdmin/config.inc.php

# set md5 authentication for hosts on the network
sed -i.bak -r 's,ident|peer,md5,g' /var/lib/pgsql/data/pg_hba.conf
internal_ip=$(hostname -I)
ip_network=$(echo $internal_ip | awk -F. '{ print $1"."$2".0.0" }')
echo "host     all             all             $ip_network/20           md5" >> /var/lib/pgsql/data/pg_hba.conf

sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/g" /var/lib/pgsql/data/postgresql.conf

# restart postgres & enable apache for start @ boot
systemctl enable httpd && systemctl start httpd
systemctl restart postgresql

setenforce 0 # set selinux to permissive now
sed -i 's,SELINUX=enforcing,SELINUX=disabled,g' /etc/sysconfig/selinux # don't load an selinux policy on boot

external_ip=$(curl http://metadata.google.internal/computeMetadata/v1/instance/network-interfaces/0/access-configs/0/external-ip -H "Metadata-Flavor: Google")
echo "Please go to the URL: http://$external_ip/phpPgAdmin to login to your postgres instance"
