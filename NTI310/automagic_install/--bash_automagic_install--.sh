#!/bin/bash

echo "Welcome to the NTI310 automagic_install script!! This code will launch nfs and ldap client + servers as well as Postgres and Django and a mail server"


# LDAP Server

gcloud compute instances create ldap-a \
    --zone us-west1-b \
    --machine-type f1-micro \
    --image-family centos-7 \
    --image-project centos-cloud \
    --tags "http-server" \
    --metadata-from-file startup-script="/Users/codes/__CODE/Linux_at_SCC_NTI/NTI310/automagic_install/lab_1_ldap/lab_1_ldap_server.sh"

ldap_server_internal_ip=$(gcloud compute instances list | grep ldap-a | awk '{ print $4 }' | tail -1)
ldap_server_external_ip=$(gcloud compute instances list | grep ldap-a | awk '{ print $5 }' | tail -1)

echo "your ldap-a internal ip is $ldap_server_internal_ip"
echo "your ldap-a internal ip is $ldap_server_internal_ip" >> /Users/codes/__CODE/Linux_at_SCC_NTI/NTI310/automagic_install/instance_internal_ip_servers.txt

echo "your ldap-a url is http://$ldap_server_external_ip/phpldapadmin"
echo "your ldap-a url is http://$ldap_server_external_ip/phpldapadmin" >> /Users/codes/__CODE/Linux_at_SCC_NTI/NTI310/automagic_install/instance_external_ip_servers.txt


# NFS Server

gcloud compute instances create nfs-a \
    --zone us-west1-b \
    --machine-type f1-micro \
    --image-family centos-7 \
    --image-project centos-cloud \
    --metadata-from-file startup-script="/Users/codes/__CODE/Linux_at_SCC_NTI/NTI310/automagic_install/lab_3_nfs/nfs_server.sh"

nfs_server_internal_ip=$(gcloud compute instances list | grep nfs-a | awk '{ print $4 }' | tail -1)
echo "your nfs-a internal ip is $nfs_server_internal_ip"
echo "your nfs-a internal ip is $nfs_server_internal_ip" >> /Users/codes/__CODE/Linux_at_SCC_NTI/NTI310/automagic_install/instance_internal_ip_servers.txt

# I use gsed on my mac since it's most similar to sed on Linux
gsed -i "s,nfs_server_ip,$nfs_server_internal_ip," /Users/codes/__CODE/Linux_at_SCC_NTI/NTI310/automagic_install/lab_5_nfs_ldap/ldap_nfs_client.sh
gsed -i "s,ldap_server_ip,$ldap_server_internal_ip," /Users/codes/__CODE/Linux_at_SCC_NTI/NTI310/automagic_install/lab_5_nfs_ldap/ldap_nfs_client.sh

gcloud compute instances create client-a \
    --zone us-west1-b \
    --machine-type f1-micro \
    --image-family ubuntu-1604-lts \
    --image-project ubuntu-os-cloud \
    --metadata-from-file startup-script="/Users/codes/__CODE/Linux_at_SCC_NTI/NTI310/automagic_install/lab_5_nfs_ldap/ldap_nfs_client.sh"

gcloud compute instances create client-b \
    --zone us-west1-b \
    --machine-type f1-micro \
    --image-family ubuntu-1604-lts \
    --image-project ubuntu-os-cloud \
    --metadata-from-file startup-script="/Users/codes/__CODE/Linux_at_SCC_NTI/NTI310/automagic_install/lab_5_nfs_ldap/ldap_nfs_client.sh"


# Django Server + Posgres server and will resolve dependancies.

gcloud compute instances create postgres-a \
    --zone us-west1-b \
    --machine-type f1-micro \
    --image-family centos-7 \
    --image-project centos-cloud \
    --tags "http-server" \
    --metadata-from-file startup-script="/Users/codes/__CODE/Linux_at_SCC_NTI/NTI310/automagic_install/lab_2_django_postgres/postgres.sh"

postgres_server_internal_ip=$(gcloud compute instances list | grep postgres-a | awk '{ print $4 }' | tail -1)
postgres_server_external_ip=$(gcloud compute instances list | grep postgres-a | awk '{ print $5 }' | tail -1)

echo "your postgres-a internal ip is $postgres_server_internal_ip"
echo "your postgres-a internal ip is $postgres_server_internal_ip" >> /Users/codes/__CODE/Linux_at_SCC_NTI/NTI310/automagic_install/instance_internal_ip_servers.txt

echo "your postgres-a url is http://$postgres_server_external_ip/phpPgAdmin"
echo "your postgres-a url is http://$postgres_server_external_ip/phpPgAdmin" >> /Users/codes/__CODE/Linux_at_SCC_NTI/NTI310/automagic_install/instance_external_ip_servers.txt

gsed -i "s,postgres_server_ip,$postgres_server_internal_ip," /Users/codes/__CODE/Linux_at_SCC_NTI/NTI310/automagic_install/lab_2_django_postgres/django.sh

gcloud compute instances create django-a \
    --zone us-west1-b \
    --machine-type f1-micro \
    --image-family centos-7 \
    --image-project centos-cloud \
    --tags "http-server" \
    --metadata-from-file startup-script="/Users/codes/__CODE/Linux_at_SCC_NTI/NTI310/automagic_install/lab_2_django_postgres/django.sh"

django_server_external_ip=$(gcloud compute instances list | grep django-a | awk '{ print $5 }' | tail -1)

echo "your django-a url is http://$django_server_external_ip:8000/admin"
echo "your django-a url is http://$django_server_external_ip:8000/admin" >> /Users/codes/__CODE/Linux_at_SCC_NTI/NTI310/automagic_install/instance_external_ip_servers.txt

# Mail server


gcloud compute instances create mail-a \
    --zone us-west1-b \
    --machine-type f1-micro \
    --image-family centos-7 \
    --image-project centos-cloud \
    --metadata-from-file startup-script="/Users/codes/__CODE/Linux_at_SCC_NTI/NTI310/automagic_install/lab_4_mail_server/mail_server_automated.sh"

mail_server_internal_ip=$(gcloud compute instances list | grep mail-a | awk '{ print $4 }' | tail -1)

echo "your mail-a internal ip is $mail_server_internal_ip"
echo "your mail-a internal ip is $mail_server_internal_ip" >> /Users/codes/__CODE/Linux_at_SCC_NTI/NTI310/automagic_install/instance_internal_ip_servers.txt
