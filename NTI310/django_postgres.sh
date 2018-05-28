#!/bin/bash

# Django code meant to run with a postgres backend already setup
# GCP - Meant to be used in a Google Cloud Project

# uses the metadata servers' dns resolver to get internal ip addresses of other hosts on the network
echo "Please input the 'name' of your postgres server (e.g. postgres-a):"
read your_server_name # stores _your_server_name_ that you want to get the ip address of
internal_ip=$(getent hosts  $your_server_name$(echo .$(hostname -f |  cut -d "." -f2-)) | awk '{ print $1 }' ) # gets the ip address
echo "Please input the database password of your postgresql server below:"
read db_password
echo "Please input the superuser password to create for django below:"
read django_password

yum install -y tree
yum -y install pip
yum -y install python-pip
pip install virtualenv
pip install --upgrade pip

#--------------------- venv ---------------------
cd /opt
virtualenv django
source /opt/django/bin/activate
pip install django psycopg2
dgjango-admin.py startproject myproject /opt/django/

adduser codes

chown -R codes . /opt/django

external_ip=$(curl http://metadata.google.internal/computeMetadata/v1/instance/network-interfaces/0/access-configs/0/external-ip -H "Metadata-Flavor: Google")
sed -i.bak "s,ALLOWED_HOSTS \= \[\],ALLOWED_HOSTS \= \['$external_ip'\],g"  /opt/django/myproject/settings.py

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
        'NAME': 'myproject',
        'USER': 'myprojectuser',
        'PASSWORD': '$db_password',
        'HOST': '$internal_ip',
        'PORT': '5432',
    }
}" >> /opt/django/myproject/settings.py

# deletes and creates the superuser
echo "from django.contrib.auth.models import User; User.objects.filter(email='root@example.com').delete(); User.objects.create_superuser('root', 'root@example.com', '$django_password')" | python /opt/django/manage.py shell

tree /opt/django/myproject

# run the following as 'codes'
sudo -u codes -E sh -c "\\
source /opt/django/bin/activate && \\
/opt/django/manage.py migrate && \\
/opt/django/manage.py runserver 0:8000 &"
