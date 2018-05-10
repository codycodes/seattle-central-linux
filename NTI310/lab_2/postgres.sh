#!/bin/bash

# contains the extra packages that we need
yum install -y epel-release
# postgres components
yum install -y python-pip python-devel gcc postgresql-server postgresql-devel postgresql-contrib

postgresql-setup initdb
# set md5 authentication
sed -i.bak "s/ident/md5/g" /var/lib/pgsql/data/pg_hba.conf

# start postgres & enable for start @ boot
systemctl start postgresql && systemctl enable postgresql

echo "Please enter your new database password:"
read db_password

echo "CREATE DATABASE myproject;
CREATE USER myprojectuser WITH PASSWORD '$db_password';
ALTER ROLE myprojectuser SET client_encoding TO 'utf8';
ALTER ROLE myprojectuser SET default_transaction_isolation TO 'read committed';
ALTER ROLE myprojectuser SET timezone TO 'UTC';
GRANT ALL PRIVILEGES ON DATABASE myproject TO myprojectuser;" > /tmp/myproject.sql
# used in our script to input our newly coded db (above) as the postgres user
sudo -i -u postgres psql -U postgres -f /tmp/myproject.sql && echo "myproject db add complete!"

systemctl status postgresql

# install the web frontend
yum -y install phpPgAdmin

# allow host access from any IP
sed -i 's,Require local,#Require local\n   Require all granted,g' /etc/httpd/conf.d/phpPgAdmin
sed -i 's,Allow from localhost,Allow from all,g' /etc/httpd/conf.d/cacti.conf

systemctl enable httpd && systemctl start httpd

setenforce 0 # set selinux to permissive now
sed -i 's,SELINUX=enforcing,SELINUX=disabled,g' /etc/sysconfig/selinux # don't load an selinux policy
