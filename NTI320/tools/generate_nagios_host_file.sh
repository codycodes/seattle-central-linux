#!/bin/bash

function make_nrpe_config {
  echo '# a minimal configuration for '$1'
  # Host Definition
  define host {
    use              linux-server       ; Inherit default values from a template
    host_name        '$1'           ; The name we are giving to this host
    alias            '$1' server    ; A longer name associated with the host
    address          '$2'         ; IP address of the host
  }
  # Service Definition
  define service {
    use                  generic-service
    host_name            '$1'
    service_description  load
    check_command        check_nrpe!check_load
  }
  define service {
    use                  generic-service
    host_name            '$1'
    service_description  users
    check_command        check_nrpe!check_users
  }
  define service {
    use                  generic-service
    host_name            '$1'
    service_description  disk
    check_command        check_nrpe!check_disk
  }
  define service {
    use                  generic-service
    host_name            '$1'
    service_description  totalprocs
    check_command        check_nrpe!check_total_procs
  }
  define service {
    use                  generic-service
    host_name            '$1'
    service_description  memory
    check_command        check_nrpe!check_mem
  }' >> ~/test
  # >> /etc/nagios/conf.d/$1.cfg
}

instance_info="$(gcloud compute instances list)"
for client_name in $(echo "$instance_info" | awk 'NR >= 2 { print $1 }');
do
  nrpe_internal_ip=$(echo "$instance_info" | grep $client_name | awk '{ print $4 }')
  make_nrpe_config "$client_name" "$nrpe_internal_ip"
done;

# Old iteration
# for server_name in $(gcloud compute instances list | awk 'NR >= 2 { print $1 }');
# do
#   server_details="$(gcloud compute instances list | grep $server_name);"
#   client_name=$(echo $server_details | awk '{ print $1 }')
#   nrpe_internal_ip=$(echo $server_details | awk '{ print $4 }')
#   echo $client_name $nrpe_internal_ip
# done;
