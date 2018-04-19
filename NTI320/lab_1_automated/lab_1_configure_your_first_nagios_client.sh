#!/bin/bash
# configuration for client-a
##############
#On the client#
###############
apt-get -y install nagios-plugins nagios-nrpe-server
echo "Enter the internal ip address of your nagios server: "
read internal_ip

string='command\[check_hda1\]=/usr/lib/nagios/plugins/check_disk -w 20% -c 10% -p /dev/hda1' # escape square brackets
replacement_string='command\[check_disk\]=/usr/lib/nagios/plugins/check_disk -w 20% -c 10% -p /dev/sda1'
sed -i.bak "s;$string;$replacement_string;g" /etc/nagios/nrpe.cfg # use semicolons as delimiter

sed -i "s/allowed_hosts=127.0.0.1/allowed_hosts=127.0.0.1, $internal_ip/g" /etc/nagios/nrpe.cfg # create backup file

check_mem='https://raw.githubusercontent.com/codycodes/Linux_at_SCC_NTI/master/resources/nrpe_modules/check_mem.sh'
wget --no-verbose -P /usr/lib/nagios/plugins/ $check_mem  # download check_mem script to Nagios plugins 


echo "command[check_mem]=/usr/lib/nagios/plugins/check_mem.sh -w 80 -c 90" >> /etc/nagios/nrpe.cfg
# this should happen as part of the packaging of the rpm...
systemctl restart nagios-nrpe-server.service
