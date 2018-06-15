#!/bin/bash

for config_file in $(ls /Users/codes/__CODE/Linux_at_SCC_NTI/NTI320/configuration_files/automation_final_configs/);
do
  gcloud compute scp /Users/codes/__CODE/Linux_at_SCC_NTI/NTI320/configuration_files/automation_final_configs/$config_file "nagios-a":/etc/nagios/conf.d/$config_file;
done
