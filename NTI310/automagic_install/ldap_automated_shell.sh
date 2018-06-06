#!/bin/bash

# automate install of ldap-a

gcloud compute instances create ldap-a \
    --zone us-west1-b \
    --machine-type f1-micro \
    --image-family centos-7 \
    --image-project centos-cloud \
    --tags "http-server" \
    --metadata-from-file startup-script="/Users/codes/__CODE/Linux_at_SCC_NTI/NTI310/lab_1/lab_1_ldap_client.sh"

internal_ldap_ip=$(gcloud compute instances list | grep ldap-a | awk '{ print $4 }' | tail -1)
echo $internal_ldap_ip
