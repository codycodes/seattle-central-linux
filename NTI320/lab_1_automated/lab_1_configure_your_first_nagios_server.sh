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

echo "Enter the internal ip address of your NRPE client: "
read nrpe_internal_ip
echo "Enter the name of your NRPE client: "
read client_name

echo '# a minimal configuration for '$client_name'
# Host Definition
define host {
  use              linux-server       ; Inherit default values from a template
  host_name        '$client_name'           ; The name we are giving to this host
  alias            '$client_name' server    ; A longer name associated with the host
  address          '$nrpe_internal_ip'         ; IP address of the host
}
# Service Definition
define service {
  use                  generic-service
  host_name            '$client_name'
  service_description  load
  check_command        check_nrpe!check_load
}
define service {
  use                  generic-service
  host_name            '$client_name'
  service_description  users
  check_command        check_nrpe!check_users
}
define service {
  use                  generic-service
  host_name            '$client_name'
  service_description  disk
  check_command        check_nrpe!check_disk
}
define service {
  use                  generic-service
  host_name            '$client_name'
  service_description  totalprocs
  check_command        check_nrpe!check_total_procs
}
define service {
  use                  generic-service
  host_name            '$client_name'
  service_description  memory
  check_command        check_nrpe!check_mem
}' >> /etc/nagios/conf.d/$client_name.cfg

/usr/sbin/nagios -v /etc/nagios/nagios.cfg # verify Nagios configuration

systemctl reload nagios

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

echo "Please input the 'name' of your syslog server (e.g. syslog-a)"
read your_server_name # stores _your_server_name_ that you want to get the ip address of
internal_ip=$(getent hosts  $your_server_name$(echo .$(hostname -f |  cut -d "." -f2-)) | awk '{ print $1 }' ) # gets the ip address
echo "*.info;mail.none;authpriv.none;cron.none   @$internal_ip" >> /etc/rsyslog.conf && systemctl restart rsyslog.service
