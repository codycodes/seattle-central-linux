#!/bin/python
import os
# configuration for client-a


if __name__ == "__main__":
    os.system('apt-get -y install nagios-plugins nagios-nrpe-server')
    os.system('cp /etc/nagios/nrpe.cfg /etc/nagios/nrpe.cfg.bak')
    internal_ip = input("Enter the internal ip address of your nagios-a server: ")
    os.system("sed -i 's/allowed_hosts=127.0.0.1/allowed_hosts=127.0.0.1, " + internal_ip + "/g' /etc/nagios/nrpe.cfg")
    os.system("systemctl restart nagios-nrpe-server.service")
