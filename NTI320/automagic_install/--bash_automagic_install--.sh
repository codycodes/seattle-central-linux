#!/bin/bash

echo "Welcome to the NTI320 automagic_install script! This code will launch nfs and ldap client + servers as well as Postgres and Django and a mail server"

bash /Users/codes/__CODE/Linux_at_SCC_NTI/NTI310/automagic_install/--bash_automagic_install--.sh

user_filepath='/Users/codes/__CODE'
# rpm_url=''
#
#
# # Repo Server
#
# gsed -i "s,rpm_url,$rpm_url," $user_filepath/Linux_at_SCC_NTI/NTI320/automagic_install/lab_5_repo/repo_server.sh

gcloud compute instances create repo-a \
    --zone us-west1-b \
    --machine-type f1-micro \
    --image-family centos-7 \
    --image-project centos-cloud \
    --metadata-from-file startup-script="$user_filepath/Linux_at_SCC_NTI/NTI320/automagic_install/lab_5_repo/repo_server.sh"

repo_server_internal_ip=$(gcloud compute instances list | grep repo-a | awk '{ print $4 }' | tail -1)
repo_server_external_ip=$(gcloud compute instances list | grep repo-a | awk '{ print $5 }' | tail -1)

echo "your repo-a internal ip is $repo_server_internal_ip"
echo "your repo-a internal ip is $repo_server_internal_ip" >> $user_filepath/Linux_at_SCC_NTI/NTI320/automagic_install/instance_internal_ip_servers.txt

echo "your repo-a external ip is http://$repo_server_external_ip"
echo "your repo-a external ip is http://$repo_server_external_ip" >> $user_filepath/Linux_at_SCC_NTI/NTI320/automagic_install/instance_external_ip_servers.txt


# Rsyslog Server

gcloud compute instances create rsyslog-a \
    --zone us-west1-b \
    --machine-type f1-micro \
    --image-family centos-7 \
    --image-project centos-cloud \
    --metadata-from-file startup-script="$user_filepath/Linux_at_SCC_NTI/NTI320/automagic_install/lab_6_rsyslog/rsyslog.sh"

syslog_server_internal_ip=$(gcloud compute instances list | grep syslog-a | awk '{ print $4 }' | tail -1)


# Build Server

gsed -i "s,repo_internal_ip,$repo_server_internal_ip," $user_filepath/Linux_at_SCC_NTI/NTI320/automagic_install/lab_4_build/build_server.sh
gsed -i "s,syslog_internal_ip,$syslog_server_internal_ip," $user_filepath/Linux_at_SCC_NTI/NTI320/automagic_install/lab_4_build/build_server.sh

gcloud compute instances create build-a \
    --zone us-west1-b \
    --machine-type f1-micro \
    --image-family centos-7 \
    --image-project centos-cloud \
    --metadata-from-file startup-script="$user_filepath/Linux_at_SCC_NTI/NTI320/automagic_install/lab_4_build/build_server.sh"


# Nagios Server

gsed -i "s,repo_internal_ip,$repo_server_internal_ip," $user_filepath/Linux_at_SCC_NTI/NTI320/automagic_install/lab_1_nagios/nagios_server.sh
gsed -i "s,syslog_internal_ip,$syslog_server_internal_ip," $user_filepath/Linux_at_SCC_NTI/NTI320/automagic_install/lab_1_nagios/nagios_server.sh

gcloud compute instances create nagios-a \
    --zone us-west1-b \
    --machine-type f1-micro \
    --image-family centos-7 \
    --image-project centos-cloud \
    --tags "http-server" \
    --metadata-from-file startup-script="$user_filepath/Linux_at_SCC_NTI/NTI320/automagic_install/lab_1_nagios/nagios_server.sh"

nagios_server_internal_ip=$(gcloud compute instances list | grep nagios-a | awk '{ print $4 }' | tail -1)
nagios_server_external_ip=$(gcloud compute instances list | grep nagios-a | awk '{ print $5 }' | tail -1)

echo "your nagios-a internal ip is $nagios_server_internal_ip"
echo "your nagios-a internal ip is $nagios_server_internal_ip" >> $user_filepath/Linux_at_SCC_NTI/NTI320/automagic_install/instance_internal_ip_servers.txt

echo "your nagios-a external ip is http://$nagios_server_external_ip/nagios"
echo "your nagios-a external ip is http://$nagios_server_external_ip/nagios" >> $user_filepath/Linux_at_SCC_NTI/NTI320/automagic_install/instance_external_ip_servers.txt
echo "now sleeping to allow Nagios to install gracefully"
sleep 120


# Cacti Server

gsed -i "s,repo_internal_ip,$repo_server_internal_ip," $user_filepath/Linux_at_SCC_NTI/NTI320/automagic_install/lab_2_cacti/cacti_install.sh
gsed -i "s,syslog_internal_ip,$syslog_server_internal_ip," $user_filepath/Linux_at_SCC_NTI/NTI320/automagic_install/lab_2_cacti/cacti_install.sh


gcloud compute instances create cacti-a \
    --zone us-west1-b \
    --machine-type f1-micro \
    --image-family centos-7 \
    --image-project centos-cloud \
    --tags "http-server" \
    --metadata-from-file startup-script="$user_filepath/Linux_at_SCC_NTI/NTI320/automagic_install/lab_2_cacti/cacti_install.sh"

cacti_server_internal_ip=$(gcloud compute instances list | grep cacti-a | awk '{ print $4 }' | tail -1)
cacti_server_external_ip=$(gcloud compute instances list | grep cacti-a | awk '{ print $5 }' | tail -1)

echo "your cacti-a internal ip is $cacti_server_internal_ip"
echo "your cacti-a internal ip is $cacti_server_internal_ip" >> $user_filepath/Linux_at_SCC_NTI/NTI320/automagic_install/instance_internal_ip_servers.txt

echo "your cacti-a external ip is http://$cacti_server_external_ip/cacti"
echo "your cacti-a external ip is http://$cacti_server_external_ip/cacti" >> $user_filepath/Linux_at_SCC_NTI/NTI320/automagic_install/instance_external_ip_servers.txt
