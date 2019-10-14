#!/bin/bash
#
# Title:      PSAutomate
# Based On:   PGBlitz (Reference Title File)
# Original Author(s):  Admin9705 - Deiteq
# PSAutomate Auther: fattylewis
# URL:        https://psautomate.io - http://github.psautomate.io
# GNU:        General Public License v3.0
################################################################################

# Starting Actions
touch /psa/logs/psablitz.log

echo "" >> /psa/logs/psablitz.log
echo "" >> /psa/logs/psablitz.log
echo "----------------------------" >> /psa/logs/psablitz.log
echo "PSA Blitz Log - First Startup" >> /psa/logs/psablitz.log
chown -R 1000:1000 "{{hdpath}}/downloads"
chmod -R 775 "{{hdpath}}/downloads"
chown -R 1000:1000 "{{hdpath}}/move"
chmod -R 775 "{{hdpath}}/move"

startscript () {
while read p; do

# Repull excluded folder
 wget -qN https://blahblah/PGBlitz/psaclone/v8.6/functions/exclude -P /psa/var/

  cleaner="$(cat /psa/var/cloneclean)"
  useragent="$(cat /psa/var/uagent)"

  let "cyclecount++"
  echo "----------------------------" >> /psa/logs/psablitz.log
  echo "PSA Blitz Log - Cycle $cyclecount" >> /psa/logs/psablitz.log
  echo "" >> /psa/logs/psablitz.log
  echo "Utilizing: $p" >> /psa/logs/psablitz.log

  rclone moveto "{{hdpath}}/downloads/" "{{hdpath}}/transfer/" \
  --config /psa/rclone/psablitz.conf \
  --log-file=/psa/logs/psablitz.log \
  --log-level ERROR --stats 5s --stats-file-name-length 0 \
  --exclude="**_HIDDEN~" --exclude=".unionfs/**" \
  --exclude="**partial~" --exclude=".unionfs-fuse/**" \
  --exclude=".fuse_hidden**" --exclude="**.grab/**" \
  --exclude="**sabnzbd**" --exclude="**nzbget**" \
  --exclude="**qbittorrent**" --exclude="**rutorrent**" \
  --exclude="**deluge**" --exclude="**transmission**" \
  --exclude="**jdownloader**" --exclude="**makemkv**" \
  --exclude="**handbrake**" --exclude="**bazarr**" \
  --exclude="**ignore**"  --exclude="**inProgress**"

  chown -R 1000:1000 "{{hdpath}}/move"
  chmod -R 775 "{{hdpath}}/move"

  rclone moveto "{{hdpath}}/move" "${p}{{encryptbit}}:/" \
  --config /psa/rclone/psablitz.conf \
  --log-file=/psa/logs/psablitz.log \
  --log-level INFO --stats 5s --stats-file-name-length 0 \
  --tpslimit 12 \
  --checkers=20 \
  --transfers=16 \
  --bwlimit {{bandwidth.stdout}}M \
  --user-agent="$useragent" \
  --drive-chunk-size={{dcs}} \
  --exclude="**_HIDDEN~" --exclude=".unionfs/**" \
  --exclude="**partial~" --exclude=".unionfs-fuse/**" \
  --exclude=".fuse_hidden**" --exclude="**.grab/**"  \
  --exclude="**sabnzbd**" --exclude="**nzbget**" \
  --exclude="**qbittorrent**" --exclude="**rutorrent**" \
  --exclude="**deluge**" --exclude="**transmission**" \
  --exclude="**jdownloader**" --exclude="**makemkv**" \
  --exclude="**handbrake**" --exclude="**bazarr**" \
  --exclude="**ignore**"  --exclude="**inProgress**"

  echo "Cycle $cyclecount - Sleeping for 30 Seconds" >> /psa/logs/psablitz.log
  cat /psa/logs/psablitz.log | tail -200 > /psa/logs/psablitz.log
  #sed -i -e "/Duplicate directory found in destination/d" /psa/logs/pgblitz.log
  sleep 30

  #Quick fix
  # Remove empty directories
  #find "$dlpath/downloads/" -mindepth 2 -type d -empty -exec rm -rf {} \;
  #find "$dlpath/move/" -type d -empty -exec rm -rf {} \;
  #find "$dlpath/move/" -mindepth 2 -type f -cmin +5 -size +1M -exec rm -rf {} \;

  # Remove empty directories
  find "{{hdpath}}/transfer/" -mindepth 2 -type d -mmin +2 -empty -exec rm -rf {} \;

  # Removes garbage | torrent folder excluded
  find "{{hdpath}}/downloads" -mindepth 2 -type d -cmin +$cleaner  $(printf "! -name %s " $(cat /psa/var/exclude)) -empty -exec rm -rf {} \;
  find "{{hdpath}}/downloads" -mindepth 2 -type f -cmin +$cleaner  $(printf "! -name %s " $(cat /psa/var/exclude)) -size +1M -exec rm -rf {} \;

done </psa/var/.blitzfinal
}

# keeps the function in a loop
cheeseballs=0
while [[ "$cheeseballs" == "0" ]]; do startscript; done
