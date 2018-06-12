#!/bin/bash
yum -y install createrepo
yum -y install httpd
yum -y install wget
mkdir -p /repos/centos/7/extras/x86_64/Packages/

setenforce 0
systemctl enable httpd
systemctl start httpd

ln -s  /repos/centos /var/www/html/centos

# Configure apache
sed -i.bak '144i     Options All' /etc/httpd/conf/httpd.conf
sed -i '145i    # Disable directory index so that it will index our repos' /etc/httpd/conf/httpd.conf
sed -i '146i     DirectoryIndex disabled' /etc/httpd/conf/httpd.conf
sed -i 's/^/#/' /etc/httpd/conf.d/welcome.conf

chown -R apache:apache /repos/
systemctl restart httpd

rpm_url=''
wget --no-verbose -P /repos/centos/7/extras/x86_64/Packages/ $rpm_url

createrepo --update /repos/centos/7/extras/x86_64/Packages/
