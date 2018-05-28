gcloud compute instances create postgres-a \
    --zone us-west1-b \
    --machine-type f1-micro \
    --image-family centos-7 \
    --image-project centos-cloud \

gcloud compute instances create django-a \
    --zone us-west1-b \
    --machine-type f1-micro \
    --image-family centos-7 \
    --image-project centos-cloud \
    --tags "http-server","https-server"
