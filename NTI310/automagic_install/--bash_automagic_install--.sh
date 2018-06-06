#!/bin/bash

# LDAP Server + LDAP Client

# Django Server + Posgres server and will resolve dependancies.

echo "Welcome! This code will launch nfs and ldap client + servers as well as Postgres and Django"

# NFS Server + NFS Client

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
gsed -i "s,nfs_server_ip,$nfs_server_internal_ip" /Users/codes/__CODE/Linux_at_SCC_NTI/NTI310/automagic_install/lab_3_nfs/nfs_client.sh

gcloud compute instances create nfs-client-a \
    --zone us-west1-b \
    --machine-type f1-micro \
    --image-family ubuntu-1604-lts \
    --image-project ubuntu-os-cloud \
    --metadata-from-file startup-script="/Users/codes/__CODE/Linux_at_SCC_NTI/NTI310/automagic_install/lab_3_nfs/nfs_client.sh"


# LDAP Server + LDAP Client

gcloud compute instances create ldap-a \
    --zone us-west1-b \
    --machine-type f1-micro \
    --image-family centos-7 \
    --image-project centos-cloud \
    --tags "http-server" \
    --metadata-from-file startup-script="/Users/codes/__CODE/Linux_at_SCC_NTI/NTI310/automagic_install/lab_1_ldap/lab_1_ldap_server.sh"

ldap_server_internal_ip=$(gcloud compute instances list | grep ldap-a | awk '{ print $4 }' | tail -1)

echo "your ldap-a internal ip is $ldap_server_internal_ip"
echo "your ldap-a internal ip is $ldap_server_internal_ip" >> /Users/codes/__CODE/Linux_at_SCC_NTI/NTI310/automagic_install/instance_internal_ip_servers.txt

gsed -i "s,ldap_server_ip,$ldap_server_internal_ip" /Users/codes/__CODE/Linux_at_SCC_NTI/NTI310/automagic_install/lab_1_ldap/lab_1_ldap_client.sh

gcloud compute instances create nfs-client-a \
    --zone us-west1-b \
    --machine-type f1-micro \
    --image-family ubuntu-1604-lts \
    --image-project ubuntu-os-cloud \
    --metadata-from-file startup-script="/Users/codes/__CODE/Linux_at_SCC_NTI/NTI310/automagic_install/lab_1_ldap/lab_1_ldap_client.sh"
