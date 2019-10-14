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
# Variable recall comes from /functions/variables.sh
################################################################################
executelocal () {

# Reset Front Display
rm -rf psautomate/deployed.version

# Call Variables
psaclonevars

# to remove all service running prior to ensure a clean launch
ansible-playbook /psa/psaclone/ymls/remove.yml

# builds multipath
multihdreadonly

# deploy union
multihds=$(cat /psa/var/.tmp.multihd)
ansible-playbook /psa/psaclone/ymls/local.yml -e "multihds=$multihds hdpath=$hdpath"

# stores deployed version
echo "le" > /psa/rclone/deployed.version

# display edition final
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
💪 DEPLOYED: PG Local Edition
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

read -rp '↘️  Acknowledge Info | Press [ENTER] ' typed < /dev/tty

}
