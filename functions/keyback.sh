#!/bin/bash
#
# Title:      PSAutomate
# Based On:   PGBlitz (Reference Title File)
# Original Author(s):  Admin9705 - Deiteq
# PSAutomate Auther: fattylewis
# URL:        https://psautomate.io - http://github.psautomate.io
# GNU:        General Public License v3.0
################################################################################

### NOTE TO DELETE KEYS THAT EXIST WHEN BACKING UP
keybackup () {

serverid=$(cat /psa/var/psa.serverid)

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 System Message: Backing Up to GDrive - $serverid
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

NOTE: Standby, takes a minute!

EOF
rclone purge --config /psa/rclone/psablitz.conf gd:/psautomate/backup/keys/$serverid
rclone copy --config /psa/rclone/psablitz.conf /psa/rclone/psablitz.conf gd:/psautomate/backup/keys/$serverid/conf -v --checksum --drive-chunk-size=64M
rclone copy --config /psa/rclone/psablitz.conf /psa/var/keys/processed/ gd:/psautomate/backup/keys/$serverid/keys -v --checksum --drive-chunk-size=64M

tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 System Message: Backup Complete!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
read -p '🌍 Acknowledge Info | Press [ENTER] ' typed2 < /dev/tty
}

keyrestore () {
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Standby! Conducting Key Restore Check!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
rclone lsd --config /psa/rclone/psablitz.conf gd:/psautomate/backup/keys/ | awk '{ print $5 }' > /tmp/service.keys
checkcheck=$(cat /tmp/service.keys)

if [ "$checkcheck" == "" ];then
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Either You Failed to Configure RClone with GDrive or No Backups Exist!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
  read -p '🌍 Acknowledge Info | Press [ENTER] ' typed < /dev/tty
  keymenu
fi

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Type the Name of the Backup to Restore
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

NOTE: Quit? Type > exit

EOF
cat /tmp/service.keys

echo
read -p '🌍 Type Name | Press [ENTER]: ' typed < /dev/tty

if [ "$typed" == "exit" ]; then keymenu; fi

grepcheck=$(cat /tmp/service.keys | grep $typed)
if [ "$grepcheck" == "" ]; then
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Failed to Type Name of a Backup on the list! Restarting process!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  read -p '🌍 Acknowledge Info | Press [ENTER] ' typed < /dev/tty
keyrestore; fi

serverid="$typed"
mkdir -p /psa/var/processed

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 System Message: Restoring Keys - $serverid
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
rclone copy --config /psa/rclone/psablitz.conf gd:/psautomate/backup/keys/$serverid/conf /psa/var/  -v --checksum --drive-chunk-size=64M
rclone copy --config /psa/rclone/psablitz.conf gd:/psautomate/backup/keys/$serverid/keys /psa/var/keys/processed/  -v --checksum --drive-chunk-size=64M

tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 System Message: Key Restoration Complete!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

NOTE: When conducting a restore, no need to share out emails and etc! Just
redeploy PGBlitz!

EOF
read -p '🌍 Acknowledge Info | Press [ENTER] ' typed2 < /dev/tty
keymenu
}
