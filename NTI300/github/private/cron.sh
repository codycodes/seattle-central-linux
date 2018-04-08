#!/bin/bash
([[  -z  $(who)  ]] && [[ $(cat /proc/uptime | cut -f1 -d".") -ge 3600 ]] && echo "Your server is still on... do you want to shut it down?" | mail -s "shut down your server" -r yourserver cgagno01@seattlecentral.edu  ) || echo "cron server reminder command failed."
