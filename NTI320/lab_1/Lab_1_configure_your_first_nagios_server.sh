#!/bin/bash
# configuration for nagios-a
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

echo "Enter the internal ip address of your repository server: "
read repo_internal_ip

echo "[nti-320]
name=Extra Packages for Centos from NTI-320 7 - $basearch
#baseurl=http://download.fedoraproject.org/pub/epel/7/$basearch <- example epel repo
# Note, this is putting repodata at packages instead of 7 and our path is a hack around that.
baseurl=http://$repo_internal_ip/centos/7/extras/x86_64/Packages/
enabled=1
gpgcheck=0
" >> /etc/yum.repos.d/NTI-320.repo
