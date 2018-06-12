#!/bin/bash

echo "Welcome to the NTI320 automagic_install script! This code will launch nfs and ldap client + servers as well as Postgres and Django and a mail server"

user_filepath='/Users/codes/__CODE'
rpm_url=''

# Repo Server

gsed -i "s,rpm_url,$rpm_url," $user_filepath/Linux_at_SCC_NTI/NTI320/automagic_install/lab_5_repo/repo_server.sh

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
echo "your repo-a external ip is http://$repo_server_external_ip" >> $user_filepath/Linux_at_SCC_NTI/NTI320/automagic_install/instance_internal_ip_servers.txt


# TODO:Rsyslog Server

syslog_server_internal_ip=$(gcloud compute instances list | grep syslog-a | awk '{ print $4 }' | tail -1)

# Build Server

gcloud compute instances create build-a \
    --zone us-west1-b \
    --machine-type f1-micro \
    --image-family centos-7 \
    --image-project centos-cloud \
    --metadata-from-file startup-script="$user_filepath/Linux_at_SCC_NTI/NTI320/automagic_install/lab_4_build/build_server.sh"

gsed -i "s,repo_internal_ip,$repo_server_internal_ip," $user_filepath/Linux_at_SCC_NTI/NTI320/automagic_install/lab_4_build/build_server.sh
gsed -i "s,syslog_internal_ip,$syslog_server_internal_ip," $user_filepath/Linux_at_SCC_NTI/NTI320/automagic_install/lab_4_build/build_server.sh

# TODO: Nagios
# TODO: Cacti

# # I use gsed on my mac since it's most similar to sed on Linux
# gsed -i "s,nfs_server_ip,$nfs_server_internal_ip," /Users/codes/__CODE/Linux_at_SCC_NTI/NTI310/automagic_install/lab_5_nfs_ldap/ldap_nfs_client.sh
# gsed -i "s,ldap_server_ip,$ldap_server_internal_ip," /Users/codes/__CODE/Linux_at_SCC_NTI/NTI310/automagic_install/lab_5_nfs_ldap/ldap_nfs_client.sh
#
# gcloud compute instances create client-a \
#     --zone us-west1-b \
#     --machine-type f1-micro \
#     --image-family ubuntu-1604-lts \
#     --image-project ubuntu-os-cloud \
#     --metadata-from-file startup-script="/Users/codes/__CODE/Linux_at_SCC_NTI/NTI310/automagic_install/lab_5_nfs_ldap/ldap_nfs_client.sh"
#
# gcloud compute instances create client-b \
#     --zone us-west1-b \
#     --machine-type f1-micro \
#     --image-family ubuntu-1604-lts \
#     --image-project ubuntu-os-cloud \
#     --metadata-from-file startup-script="/Users/codes/__CODE/Linux_at_SCC_NTI/NTI310/automagic_install/lab_5_nfs_ldap/ldap_nfs_client.sh"
#
#
# # Django Server + Posgres server and will resolve dependancies.
#
# gcloud compute instances create postgres-a \
#     --zone us-west1-b \
#     --machine-type f1-micro \
#     --image-family centos-7 \
#     --image-project centos-cloud \
#     --tags "http-server" \
#     --metadata-from-file startup-script="/Users/codes/__CODE/Linux_at_SCC_NTI/NTI310/automagic_install/lab_2_django_postgres/postgres.sh"
#
# postgres_server_internal_ip=$(gcloud compute instances list | grep postgres-a | awk '{ print $4 }' | tail -1)
# postgres_server_external_ip=$(gcloud compute instances list | grep postgres-a | awk '{ print $5 }' | tail -1)
#
# echo "your postgres-a internal ip is $postgres_server_internal_ip"
# echo "your postgres-a internal ip is $postgres_server_internal_ip" >> /Users/codes/__CODE/Linux_at_SCC_NTI/NTI310/automagic_install/instance_internal_ip_servers.txt
#
# echo "your postgres-a url is http://$postgres_server_external_ip/phpPgAdmin"
# echo "your postgres-a url is http://$postgres_server_external_ip/phpPgAdmin" >> /Users/codes/__CODE/Linux_at_SCC_NTI/NTI310/automagic_install/instance_external_ip_servers.txt
#
# gsed -i "s,postgres_server_ip,$postgres_server_internal_ip," /Users/codes/__CODE/Linux_at_SCC_NTI/NTI310/automagic_install/lab_2_django_postgres/django.sh
#
# gcloud compute instances create django-a \
#     --zone us-west1-b \
#     --machine-type f1-micro \
#     --image-family centos-7 \
#     --image-project centos-cloud \
#     --tags "http-server" \
#     --metadata-from-file startup-script="/Users/codes/__CODE/Linux_at_SCC_NTI/NTI310/automagic_install/lab_2_django_postgres/django.sh"
#
# django_server_external_ip=$(gcloud compute instances list | grep django-a | awk '{ print $5 }' | tail -1)
#
# echo "your django-a url is http://$django_server_external_ip:8000/admin"
# echo "your django-a url is http://$django_server_external_ip:8000/admin" >> /Users/codes/__CODE/Linux_at_SCC_NTI/NTI310/automagic_install/instance_external_ip_servers.txt
#
# # Mail server
#
#
# gcloud compute instances create mail-a \
#     --zone us-west1-b \
#     --machine-type f1-micro \
#     --image-family centos-7 \
#     --image-project centos-cloud \
#     --metadata-from-file startup-script="/Users/codes/__CODE/Linux_at_SCC_NTI/NTI310/automagic_install/lab_4_mail_server/mail_server_automated.sh"
#
# mail_server_internal_ip=$(gcloud compute instances list | grep mail-a | awk '{ print $4 }' | tail -1)
#
# echo "your mail-a internal ip is $mail_server_internal_ip"
# echo "your mail-a internal ip is $mail_server_internal_ip" >> /Users/codes/__CODE/Linux_at_SCC_NTI/NTI310/automagic_install/instance_internal_ip_servers.txt
