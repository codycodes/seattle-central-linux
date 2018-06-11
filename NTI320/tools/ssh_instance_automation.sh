for server in $(gcloud compute instances list | awk 'NR >= 2 { print $1 }');
do
  gcloud compute ssh codygagnon@$server --command="touch ~/the_lan_before_time"
done
