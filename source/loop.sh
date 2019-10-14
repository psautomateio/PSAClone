#!/bin/bash
#
# Title:      PSAutomate
# Based On:   PGBlitz (Reference Title File)
# Original Author(s):  Admin9705 - Deiteq
# PSAutomate Auther: fattylewis
# URL:        https://psautomate.io - http://github.psautomate.io
# GNU:        General Public License v3.0
################################################################################
admin9705="9705"
sleep 2

echo "" > /psa/logs/transfer.log
echo "" >> /psa/logs/transfer.log
echo "----------------------------" >> /psa/logs/transfer.log
echo "PSABlitz Log - First Startup" >> /psa/logs/transfer.log
rm -rf /psa/logs/.transfer_list
rm -rf /psa/logs/.temp_list

var1=$(cat /psa/rclone/deployed.version)
if [[ "$var1" == "gd" ]]; then var2="GDrive Unencrypted"
elif [[ "$var1" == "gc" ]]; then var2="GDrive Encrypted"
elif [[ "$var1" == "sd" ]]; then var2="SDrive Unencrypted"
elif [[ "$var1" == "sc" ]]; then var2="SDrive Encrypted"; fi

if [[ "$var1" == "sd" || "$var1" == "sc" ]]; then
  blitzcount=$(wc -l /psa/var/.blitzlist | awk '{print $1}')
  keyloop=0
fi

while [[ "$admin9705" == "9705" ]]; do

  let cyclecount++
    echo "--------------------------------------------------------" >> /psa/logs/transfer.log
    echo "PSA Blitz Log - Cycle $cyclecount - $var2" >> /psa/logs/transfer.log

  if [[ "$var1" == "sd" || "$var1" == "sc" ]]; then
    let keyloop++
    echo "$keyloop" > /psa/rclone/keyloop
    currentkey=$(sed -n "${keyloop}p" /psa/var/.blitzlist)
    echo "$currentkey" > /psa/rclone/currentkey
    echo "Shared Key   - $currentkey" >> /psa/logs/transfer.log
    if [[ "$keyloop" -ge "$blitzcount" ]]; then keyloop=0; fi
  fi

  echo "" >> /psa/logs/transfer.log
  bash /psa/rclone/transfer.sh

  # cat /psa/logs/transfer.log | tail -200 > /psa/logs/transfer.log
  echo "" >> /psa/logs/transfer.log
  echo "Cycle $cyclecount Complete - Sleeping 5 Seconds" >> /psa/logs/transfer.log
  echo "" >> /psa/logs/transfer.log
  sleep 2
  primepath="$(cat /psa/var/hd.path)"
  find "$primepath/transfer" -mindepth 1 -type d -mmin +1 -empty -delete

done
