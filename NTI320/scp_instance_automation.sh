touch ~/pretty_fly_for_a_wifi;

for server in $(gcloud compute instances list | awk 'NR >= 2 { print $1 }');
do
  gcloud compute scp ~/pretty_fly_for_a_wifi $server:~/;
done
