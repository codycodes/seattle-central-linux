#!/bin/bash

# Django code meant to run with a postgres backend already setup

# get this out of the way first...
echo "Please input the internal ip address of your postgresql server below:"
read internal_ip

echo "Please input the database password of your postgresql server below:"
read db_password

yum install -y tree
yum install -y telnet
yum -y install pip
yum -y install python-pip
pip install virtualenv
pip install --upgrade pip

mkdir /opt/django
cd /opt/django
virtualenv myprojectenv
source myprojectenv/bin/activate
pip install django psycopg2
django-admin.py startproject myproject .

useradd -r -s /sbin/nologin django-admin
chown -R django-admin . /opt/django

external_ip=$(curl http://metadata.google.internal/computeMetadata/v1/instance/network-interfaces/0/access-configs/0/external-ip -H "Metadata-Flavor: Google")
sed "s,ALLOWED_HOSTS \= \[\], ALLOWED_HOSTS \= \['$external_ip'\],g"

cp /opt/django/myproject/settings.py /opt/django/myproject/settings.py.bak

python << END
# inline Python script to change the DATABASES configuration for django
settings_file_read = open("/opt/django/myproject/settings.py", "r+")
count = 0
remove_line = False

new_settings_file = ""

for line in settings_file_read:
    if "DATABASES = {" in line:
        remove_line = True

    if remove_line:
        if "{" in line:
            count = count + 1
        if "}" in line:
            count = count - 1
        settings_file_read.next()
        if count == 0:
            remove_line = False
    else:
        new_settings_file = new_settings_file + line

settings_file_read.close()

settings_file_write = open("/opt/django/myproject/settings.py", "w")
settings_file_write.write(new_settings_file)

END

echo "DATABASES = {
    'default':{
        'ENGINE': 'django.db.backends.postgresql_psycopg2',
        'NAME': 'nti310',
        'USER': 'myprojectuser',
        'PASSWORD': '$db_password',
        'HOST': '$internal_ip',
        'PORT': '5432',
    }
}" >> /opt/django/myproject/settings.py

tree myproject
