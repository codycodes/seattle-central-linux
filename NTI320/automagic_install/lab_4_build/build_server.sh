#!/bin/bash

# Begin by installing the correct programs for building & dependencies we'll need:
yum -y install rpm-build make gcc git

# For if we need to wget things from the web at some point
yum -y install wget

# Use this command to configure our top directory we're building in (in this case */root/rpmbuild*)
echo '%\_topdir %(echo $HOME)/rpmbuild' > ~/.rpmmacros

# Create the directory structure we'll use for our build process:
mkdir -p -v /root/rpmbuild/{BUILD,RPMS,SOURCES,SPECS,SRPMS}

echo "[nti-320]
name=Extra Packages for Centos from NTI-320 7 - $basearch
#baseurl=http://download.fedoraproject.org/pub/epel/7/$basearch <- example epel repo
# Note, this is putting repodata at packages instead of 7 and our path is a hack around that.
baseurl=http://repo_internal_ip/centos/7/extras/x86_64/Packages/
enabled=1
gpgcheck=0
" >> /etc/yum.repos.d/NTI-320.repo

echo "*.info;mail.none;authpriv.none;cron.none   @syslog_internal_ip" >> /etc/rsyslog.conf && systemctl restart rsyslog.service
