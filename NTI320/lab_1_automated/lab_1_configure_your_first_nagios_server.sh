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

echo '# a minimal configuration for
# Host Definition
define host {
  use              linux-server       ; Inherit default values from a template
  host_name        client-a           ; The name we are giving to this host
  alias            client-a server    ; A longer name associated with the host
  address          10.142.0.3         ; IP address of the host
}
# Service Definition
define service {
  use                  generic-service
  host_name            client-a
  service_description  load
  check_command        check_nrpe!check_load
}
define service {
  use                  generic-service
  host_name            client-a
  service_description  users
  check_command        check_nrpe!check_users
}
define service {
  use                  generic-service
  host_name            client-a
  service_description  disk
  check_command        check_nrpe!check_disk
}
define service {
  use                  generic-service
  host_name            client-a
  service_description  totalprocs
  check_command        check_nrpe!check_total_procs
}
define service {
  use                  generic-service       ; Name of the service template to apply
  host_name            client-a
  service_description  memory
  check_command        check_nrpe!check_mem
}' >> /etc/nagios/conf.d/client-a.cfg
