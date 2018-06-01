Name:		startup
Version: 	0.1
Release:	1%{?dist}
Summary: 	A collection of configuration changes

Group:		NTI-320
License:	GPL2+
URL:		https://github.com/nic-instruction/hello-NTI-320
Source0:        https://github.com/nic-instruction/hello-NTI-320/startup-0.1.tar.gz

BuildRequires:	gcc, python >= 1.3
Requires:	bash, net-snmp, net-snmp-utils, nrpe, nagios-plugins-all

%description
This package contains customization for a monitoring server, a trending server and a   logserver on the nti320 network.

%prep
%setup -q

%build
%define _unpackaged_files_terminate_build 0

%install

rm -rf %{buildroot}
mkdir -p %{buildroot}/usr/lib64/nagios/plugins/
mkdir -p %{buildroot}/etc/nrpe.d/
mkdir -p %{buildroot}/tmp/

install -m 0755 nti-sanity.sh %{buildroot}/usr/lib64/nagios/plugins/

install -m 0744 nti320.cfg %{buildroot}/etc/nrpe.d/

%clean

%files
%defattr(-,root,root)
/usr/lib64/nagios/plugins/nti-sanity.sh


%config
/etc/nrpe.d/nti320.cfg

%doc



%post

touch /thisworked

systemctl enable snmpd
systemctl start snmpd
sed -i.bak 's,/dev/hda1,/dev/sda1,'  /etc/nagios/nrpe.cfg

echo "Enter the internal ip address of your nagios server: "
read nagios_internal_ip
sed -i "s/allowed_hosts=127.0.0.1/allowed_hosts=127.0.0.1, $nagios_internal_ip/g" /etc/nagios/nrpe.cfg
systemctl restart nrpe
# will retrieve all variables under the localhost using snmp version 1
snmpwalk -v 1 -c public -O e 127.0.0.1

echo "Please input the 'name' of your syslog server (e.g. syslog-a)"
read your_server_name # stores _your_server_name_ that you want to get the ip address of
internal_ip=$(getent hosts  $your_server_name$(echo .$(hostname -f |  cut -d "." -f2-)) | awk '{ print $1 }' ) # gets the ip address
echo "*.info;mail.none;authpriv.none;cron.none   @$internal_ip" >> /etc/rsyslog.conf && systemctl restart rsyslog.service

%postun
rm /thisworked
rm /etc/nrpe.d/nti320.cfg
%changelog				# changes you (and others) have made and why
