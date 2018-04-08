#! /bin/bash


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
