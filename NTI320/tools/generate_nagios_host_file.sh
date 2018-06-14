

echo '# a minimal configuration for '$client_name'
# Host Definition
define host {
  use              linux-server       ; Inherit default values from a template
  host_name        '$client_name'           ; The name we are giving to this host
  alias            '$client_name' server    ; A longer name associated with the host
  address          '$nrpe_internal_ip'         ; IP address of the host
}
# Service Definition
define service {
  use                  generic-service
  host_name            '$client_name'
  service_description  load
  check_command        check_nrpe!check_load
}
define service {
  use                  generic-service
  host_name            '$client_name'
  service_description  users
  check_command        check_nrpe!check_users
}
define service {
  use                  generic-service
  host_name            '$client_name'
  service_description  disk
  check_command        check_nrpe!check_disk
}
define service {
  use                  generic-service
  host_name            '$client_name'
  service_description  totalprocs
  check_command        check_nrpe!check_total_procs
}
define service {
  use                  generic-service
  host_name            '$client_name'
  service_description  memory
  check_command        check_nrpe!check_mem
}'
# >> /etc/nagios/conf.d/$client_name.cfg
