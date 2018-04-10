#!/bin/bash
# configuration for client-a
apt-get -y install nagios-plugins nagios-nrpe-server
cp /etc/nagios/nrpe.cfg /etc/nagios/nrpe.cfg.bak
echo "Enter the internal ip address of your nagios-a server: "
read internal_ip
sed -i 's/allowed_hosts=127.0.0.1/allowed_hosts=127.0.0.1, $internal_ip/g' /etc/nagios/nrpe.cfg
systemctl restart nagios-nrpe-server.service
