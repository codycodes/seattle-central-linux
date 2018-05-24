#!/bin/bash
# configuration for client-a
apt-get -y install nagios-plugins nagios-nrpe-server
cp /etc/nagios/nrpe.cfg /etc/nagios/nrpe.cfg.bak
echo "Enter the internal ip address of your nagios-a server: "
read internal_ip
sed -i "s/allowed_hosts=127.0.0.1/allowed_hosts=127.0.0.1, $internal_ip/g" /etc/nagios/nrpe.cfg
systemctl restart nagios-nrpe-server.service

echo "Please input the 'name' of your syslog server (e.g. syslog-a)"
read your_server_name # stores _your_server_name_ that you want to get the ip address of
internal_ip=$(getent hosts  $your_server_name$(echo .$(hostname -f |  cut -d "." -f2-)) | awk '{ print $1 }' ) # gets the ip address
echo "*.info;mail.none;authpriv.none;cron.none   @$internal_ip" >> /etc/rsyslog.conf && systemctl restart rsyslog.service
