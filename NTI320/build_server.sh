#!/bin/bash

# Begin by installing the correct programs for building & dependencies we'll need:
yum -y install rpm-build make gcc git

# For if we need to wget things from the web at some point
yum -y install wget

# Use this command to configure our top directory we're building in (in this case */root/rpmbuild*)
echo '%\_topdir %(echo $HOME)/rpmbuild' > ~/.rpmmacros

# Create the directory structure we'll use for our build process:
mkdir -p -v /root/rpmbuild/{BUILD,RPMS,SOURCES,SPECS,SRPMS}
