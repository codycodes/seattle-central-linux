#!/bin/bash
# configuration for client-a
##############
#On the client#
###############
apt-get -y install nagios-plugins nagios-nrpe-server
echo "Enter the internal ip address of your nagios server: "
read internal_ip

sed -i.bak "s/allowed_hosts=127.0.0.1/allowed_hosts=127.0.0.1, $internal_ip/g" /etc/nagios/nrpe.cfg # create backup file
string='command\[check_hda1\]=/usr/lib/nagios/plugins/check_disk -w 20% -c 10% -p /dev/hda1' # escape square brackets
replacement_string='command\[check_sda1\]=/usr/lib/nagios/plugins/check_disk -w 20% -c 10% -p /dev/sda1'
sed -i "s;$string;$replacement_string;g" /etc/nagios/nrpe.cfg # use semicolons as delimiter

echo '# create a memory-checking plugin for NRPE
# slightly modified code from https://exchange.nagios.org/directory/Plugins/System-Metrics/Memory/Check-mem-%28by-Nestor%40Toronto%29/details
if [ "$1" = "-w" ] && [ "$2" -gt "0" ] && [ "$3" = "-c" ] && [ "$4" -gt "0" ]; then
  FreeM=`free -m`
  memTotal_m=`echo "$FreeM" |grep Mem |awk '{print $2}'`
  memUsed_m=`echo "$FreeM" |grep Mem |awk '{print $3}'`
  memFree_m=`echo "$FreeM" |grep Mem |awk '{print $4}'`
  memBuffer_cache_m=`echo "$FreeM" |grep Mem |awk '{print $6}'`
  memAvailable_m=`echo "$FreeM" |grep Mem |awk '{print $7}'`
  memUsed_m=$(($memTotal_m-$memFree_m-$memBuffer_cache_m))
  memUsedPrc=`echo $((($memUsed_m*100)/$memTotal_m))||cut -d. -f1`
  if [ "$memUsedPrc" -ge "$4" ]; then
    echo "Memory: CRITICAL Total: $memTotal_m MB - Used: $memUsed_m MB - $memUsedPrc% used!|
    TOTAL=$memTotal_m;;;; USED=$memUsed_m;;;; BUFFER/CACHE=$memBuffer_cache_m;;;; AVAILABLE=$memA
    vailable_m;;;;"
    exit 2;
  elif [ "$memUsedPrc" -ge "$2" ]; then
    echo "Memory: WARNING Total: $memTotal_m MB - Used: $memUsed_m MB - $memUsedPrc% used!|T
    OTAL=$memTotal_m;;;; USED=$memUsed_m;;;; BUFFER/CACHE=$memBuffer_cache_m;;;; AVAILABLE=$memAv
    ailable_m;;;;"
    exit 1;
  else
    echo "Memory: OK Total: $memTotal_m MB - Used: $memUsed_m MB - $memUsedPrc% used|TOTAL=$
    memTotal_m;;;; USED=$memUsed_m;;;; BUFFER/CACHE=$memBuffer_cache_m;;;; AVAILABLE=$memAvailabl
    e_m;;;;"
    exit 0;
  fi
else # If inputs are not as expected, print help.
  sName="`echo $0|awk -F '/' '{print $NF}'`"
  echo -e "\n\n\t\t### $sName Version 2.1###\n"
  echo -e "# Usage:\t$sName -w -c "
  echo -e "\t\t= warnlevel and critlevel is percentage value without %\n"
  echo "# EXAMPLE:\t/usr/lib64/nagios/plugins/$sName -w 80 -c 90"
  echo -e "\nCopyright (C) 2012 Lukasz Gogolin (lukasz.gogolin@gmail.com), improved by Nestor 2
  015\n\n"
  exit
fi' >> /usr/lib/nagios/plugins/check_mem.sh

echo "command[check_mem]=/usr/lib/nagios/plugins/check_mem.sh -w 80 -c 90" >> /etc/nagios/nrpe.cfg
# this should happen as part of the packaging of the rpm...
systemctl restart nagios-nrpe-server.service
