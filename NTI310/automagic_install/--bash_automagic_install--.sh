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
echo $nfs_server_internal_ip
