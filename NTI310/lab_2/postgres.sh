#!/bin/bash

# contains the extra packages that we need
yum install epel-release -y

# postgres components
yum install python-pip python-devel gcc postgresql-server postgresql-devel postgresql-contrib -y

postgresql-setup initdb
sed -i.bak "s/ident/md5/g" /var/lib/pgsql/data/pg_hba.conf

# start postgres & enable for start @ boot
systemctl start postgresql && systemctl enable postgresql

echo 'CREATE DATABASE myproject;

CREATE USER myprojectuser WITH PASSWORD 'password';

ALTER ROLE myprojectuser SET client_encoding TO 'utf8';
ALTER ROLE myprojectuser SET default_transaction_isolation TO 'read committed';
ALTER ROLE myprojectuser SET timezone TO 'UTC';

GRANT ALL PRIVILEGES ON DATABASE myproject TO myprojectuser;' >> /tmp/myproject.sql


# used in our script to input our newly coded db (above) as the postgres user
sudo -i -u postgres psql -U postgres -f /tmp/myproject.sql

systemctl status postgresql
