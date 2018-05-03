#!/bin/bash


yum -y install net-snmp
# installs a package which gives us the snmpwalk command
yum -y install net-snmp-utils
# start snmpd and ensure that it starts on boot by simlinking to the relevant location
systemctl enable snmpd && systemctl start snmpd
# will retrieve all variables under the localhost using snmp version 1
snmpwalk -v 1 -c public -O e 127.0.0.1
