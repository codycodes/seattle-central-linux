#!/bin/bash
# configuration for nagios-a
###############
#On the server#
###############
yum -y install nagios
systemctl enable nagios && systemctl start nagios
setenforce 0
sed -i 's,SELINUX=enforcing,SELINUX=disabled,g' /etc/sysconfig/selinux # don't load an selinux policy
yum -y install httpd
systemctl enable httpd && systemctl start httpd
yum -y install nrpe
systemctl enable nrpe && systemctl start nrpe
yum -y install nagios-plugins-all
yum -y install nagios-plugins-nrpe
htpasswd -c /etc/nagios/passwd nagiosadmin

# Need to put the NRPE plugin addition into your Nagios servers' config file
echo '########### NRPE CONFIG LINE #######################
define command{
command_name check_nrpe
command_line $USER1$/check_nrpe -H $HOSTADDRESS$ -c $ARG1$
}' >> /etc/nagios/objects/commands.cfg
