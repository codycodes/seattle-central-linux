#!/bin/bash
# get yum_installed and install it
curl https://raw.githubusercontent.com/codycodes/Linux_at_SCC_NTI/master/resources/yum_installed >> yum_installed

for i in $(cat yum_installed); do
  yum -y install $i
done

# configuration for snmp-nrpe-a
#-------------------------------------NRPE
cp /etc/nagios/nrpe.cfg /etc/nagios/nrpe.cfg.bak
echo "Enter the internal ip address of your nagios-a server: "
read internal_ip
sed -i "s/allowed_hosts=127.0.0.1/allowed_hosts=127.0.0.1, $internal_ip/g" /etc/nagios/nrpe.cfg
systemctl restart nrpe
#-------------------------------------SNMP
# start snmpd and ensure that it starts on boot by simlinking to the relevant location
systemctl enable snmpd && systemctl start snmpd
# will retrieve all variables under the localhost using snmp version 1
snmpwalk -v 1 -c public -O e 127.0.0.1

echo "Please input the 'name' of your syslog server (e.g. syslog-a)"
read your_server_name # stores _your_server_name_ that you want to get the ip address of
internal_ip=$(getent hosts  $your_server_name$(echo .$(hostname -f |  cut -d "." -f2-)) | awk '{ print $1 }' ) # gets the ip address
echo "*.info;mail.none;authpriv.none;cron.none   @$internal_ip" >> /etc/rsyslog.conf && systemctl restart rsyslog.service
