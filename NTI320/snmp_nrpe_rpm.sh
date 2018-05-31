#!/bin/bash
# get yum_installed and install it
curl https://raw.githubusercontent.com/codycodes/Linux_at_SCC_NTI/master/resources/yum_installed >> yum_installed

for i in $(cat yum_installed); do
  yum -y install $i
done
