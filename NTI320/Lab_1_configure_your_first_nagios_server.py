#!/bin/python
import os


def install_nagios_server_packages():
    os.system('yum -y install nagios')
    os.system('yum -y install httpd')
    os.system('yum -y install nrpe')
    os.system('yum -y install nagios-plugins-all')
    os.system('yum -y install nagios-plugins-nrpe')


def start_nagios_server_services():
    os.system('setenforce 0')  # required for Nagios to function correctly
    os.system('systemctl enable nagios && systemctl start nagios')
    os.system('systemctl enable httpd && systemctl start httpd')
    os.system('systemctl enable nrpe && systemctl start nrpe')


def set_nagios_dashboard_password():
    # checks signal used to close to command to reprompt password if necessary
    while os.system('htpasswd -c /etc/nagios/passwd nagiosadmin') == 768:
        print("\n\n*** Please type a new password again. ***\n\n")


if __name__ == "__main__":
    install_nagios_server_packages()
    start_nagios_server_services()
    set_nagios_dashboard_password()
