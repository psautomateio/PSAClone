#!/bin/bash
#
# Title:      PSAutomate
# Based On:   PGBlitz (Reference Title File)
# Original Author(s):  Admin9705 - Deiteq
# PSAutomate Auther: fattylewis
# URL:        https://psautomate.io - http://github.psautomate.io
# GNU:        General Public License v3.0
################################################################################
# NOTES
# Variables come from what's being called from deploytransfer.sh under functions
## BWLIMIT 9 and Lower Prevents Google 750GB Google Upload Ban
################################################################################
echo "Executing Transfer Process" >> /psa/logs/transfer.log
chmod 775 -R {{hdpath}}/transfer/
chown -R 1000:1000 {{hdpath}}/transfer/

touch /psa/logs/transfer.log
touch /psa/logs/.transfer_list
touch /psa/logs/.temp_list

basicpath="$(cat /psa/var/server.hd.path)"
useragent="$(cat /psa/var/uagent)"
bwg="$(cat /psa/var/move.bw)"
bws="$(cat /psa/var/blitz.bw)"

var3=$(cat /psa/rclone/deployed.version)
if [[ "$var3" == "gd" ]]; then var4="gdrive"
elif [[ "$var3" == "gc" ]]; then var4="gdrive"
elif [[ "$var3" == "sd" ]]; then var4="sdrive"
elif [[ "$var3" == "sd" ]]; then var4="sdrive"; fi

filecount=$(wc -l /psa/logs/.transfer_list | awk '{print $1}')
echo "$filecount" > /psa/var/filecount

if [[ "$filecount" -gt 8 ]]; then
echo "Max Files of [8] Files - Pending Transfer" >> /psa/logs/transfer.log
echo "Exiting Cycle" >> /psa/logs/transfer.log
exit; fi

find /psa/transfer/ -type f > /psa/logs/.temp_list

while read p; do
  sed -i "/^$p\b/Id" /psa/logs/.temp_list
done </psa/logs/.transfer_list

head -n +1 /psa/logs/.temp_list >> /psa/logs/.transfer_list
uploadfile=$(head -n +1 /psa/logs/.temp_list)

if [[ "$uploadfile" == "" ]]; then
echo "Nothing To Upload" >> /psa/logs/transfer.log
exit; fi

chown 1000:1000 "$uploadfile"
chmod 775 "$uploadfile"

  totalchar=$(echo "${basicpath}" | awk -F"/" '{print NF-1}')
  finalcount=$((totalchar + 3))

  echo "Preparing to Upload: $uploadfile" >> /psa/logs/transfer.log
  truepath=$(echo $uploadfile | cut -d'/' -f${finalcount}-)

if [[ "$var4" == "gdrive" ]]; then
  echo "Started Upload - $var3: $uploadfile" >> /psa/logs/transfer.log
  udrive=$(cat /psa/rclone/deployed.version)

    rclone move "$uploadfile" "$udrive:/$truepath" \
    --config /psa/rclone/psablitz.conf \
    --log-file=/psa/logs/transfer.log \
    --log-level INFO --stats 5s --stats-file-name-length 0 \
    --tpslimit 6 \
    --checkers=20 \
    --min-age=30s \
    --bwlimit="$bwg"M \
    --user-agent="$useragent" \
    --drive-chunk-size={{dcs}} \
    --exclude="**_HIDDEN~" --exclude="*partial~"  \
    --exclude=".fuse_hidden**" --exclude="**.grab/**"
else
  echo "Started Shared Upload - $var3: $uploadfile" >> /psa/logs/transfer.log
  readykey=$(cat /psa/rclone/currentkey)
  uread=$(cat /psa/rclone/deployed.version)
  encryptbit=""
  if [[ "$uread" == "sc" ]]; then encryptbit="C"; fi

    rclone move "$uploadfile" "${readykey}${encryptbit}:/$truepath" \
    --config /psa/rclone/psablitz.conf \
    --log-file=/psa/logs/psablitz.log \
    --log-level INFO --stats 5s --stats-file-name-length 0 \
    --tpslimit 12 \
    --checkers=20 \
    --min-age=30s \
    --transfers=16 \
    --bwlimit="$bws"M \
    --user-agent="$useragent" \
    --drive-chunk-size={{dcs}} \
    --exclude="**_HIDDEN~" --exclude=".unionfs/**" \
    --exclude="**partial~" --exclude=".unionfs-fuse/**" \
    --exclude=".fuse_hidden**" --exclude="**.grab/**"
fi

grep -v "$uploadfile" "/psa/logs/.transfer_list" | sponge "/psa/logs/.transfer_list"
exit
