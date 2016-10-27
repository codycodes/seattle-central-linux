#! /bin/bash

#***Apache***#

##Usernames & passwords:
### user1
### linux

### user2
### superlinux

echo "installing apache server"
sudo yum -y install httpd

echo "enabling apache server"
sudo systemctl enable httpd.service

echo "starting apache server"
sudo systemctl start httpd.service

## create new default webpage
sudo sh -c 'cat > /var/www/html/index.html' << "EOF1"
<html>
<body>
<span style="font-size: 268px; top: 1px; font-family: bam_futuraCnXBdOb; color: rgb(0, 0,\
 0);">HELLO, WORLD</span>
</body>
</html>
EOF1


## create a directory for the second authenticated webpage
sudo mkdir /var/www/html/pagetwo

## edit httpd.conf to allow for authentication
sudo sed -i "151s/None/AuthConfig/1" /etc/httpd/conf/httpd.conf
sudo sed -i '159i <Directory "/var/www/html/pagetwo">' /etc/httpd/conf/httpd.conf
sudo sed -i '160i AllowOverride AuthConfig' /etc/httpd/conf/httpd.conf
sudo sed -i '161i </Directory>' /etc/httpd/conf/httpd.conf

## create usernames/passwords
sudo htpasswd -ci /var/www/html/pagetwo/.htpasswd user1 <<< linux
sudo htpasswd -i /var/www/html/pagetwo/.htpasswd user2 <<< superlinux

## create .htaccess for user authentication
sudo sh -c 'cat > /var/www/html/pagetwo/.htaccess' << "EOF2"
Authtype Basic
AuthName "Cool teachers only! hint: users: user1, user2 passwords: linux, superlinux"
AuthUserFile /var/www/html/pagetwo/.htpasswd
Require valid-user
EOF2

## set permissions
sudo chmod 644 /var/www/html/pagetwo/.htaccess
sudo chmod 644 /var/www/html/pagetwo/.htpasswd

## create webpage number two
sudo sh -c 'cat > /var/www/html/pagetwo/index.html' << EOF3
<html>
<body>
<img src="http://i.imgur.com/WqVFA2M.png" alt="You've gotta have heart!">
</body>
</html>
EOF3

sudo service httpd restart

#***Django***#

echo "Current python version:"

python --version

echo "installing virtualenv so we can give django its own version of python"

# here you can install with updates or without updates.  To install python pip with a full kernel upgrade (not somthing you would do in prod, but
# definately somthing you might do to your testing or staging server: sudo yum update

# for a prod install (no update)

# this adds the noarch release reposatory from the fedora project, wich contains python pip
# python pip is a package manager for python...

sudo rpm -iUvh https://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-8.noarch.rpm

sudo yum -y install python-pip

# Now we're installing virtualenv, which will allow us to create a python installation and environment, just for our Django server
sudo pip install virtualenv

cd /opt
# we're going to install our django libs in /opt, often used for optional or add-on.  /usr/local is also a perfectly fine place for new apps
# we want to make this env accisible to the ec2-user at first, because we don't want to have to run it as root.

sudo mkdir django
sudo chown -R ec2-user django

sleep 5

cd django
sudo virtualenv django-env

echo "activating virtualenv"

source /opt/django/django-env/bin/activate

echo "to switch out of virtualenv, type deactivate"

echo "now using:"

which python

sudo chown -R ec2-user /opt/django

echo "installing django"
 
sudo ip install Django

echo "django admin is version:"

django-admin --version

django-admin startproject project1

sudo yum -y install tree

echo "here's our new django project dir"

tree project1

sleep 5

python /opt/django/project1/manage.py runserver 0.0.0.0:8000


