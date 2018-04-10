#!/bin/bash
yum -y install nagios
systemctl enable nagios && systemctl start nagios
setenforce 0
yum -y install httpd
systemctl enable httpd && systemctl start httpd
yum -y install nrpe
systemctl enable nrpe && systemctl start nrpe
yum -y install nagios-plugins-all
yum -y install nagios-plugins-nrpe
htpasswd -c /etc/nagios/passwd nagiosadmin
