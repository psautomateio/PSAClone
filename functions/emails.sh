#!/bin/bash
#
# Title:      PSAutomate
# Based On:   PGBlitz (Reference Title File)
# Original Author(s):  Admin9705 - Deiteq
# PSAutomate Auther: fattylewis
# URL:        https://psautomate.io - http://github.psautomate.io
# GNU:        General Public License v3.0
################################################################################
emailgen () {

rm -rf /psa/var/.emailbuildlist 1>/dev/null 2>&1
rm -rf /psa/var/.emaillist  1>/dev/null 2>&1

ls -la /psa/var/.blitzkeys | awk '{print $9}' | tail -n +4 > /psa/var/.emailbuildlist
while read p; do
  cat /psa/var/.blitzkeys/$p | grep client_email | awk '{print $2}' | sed 's/"//g' | sed 's/,//g' >> /psa/var/.emaillist
done </psa/var/.emailbuildlist

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 EMail Share Generator ~ psaclone.psautomate.io
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

PURPOSE: Share out the service accounts for the TeamDrives. Failing to do
so will result in PGBlitz Failing!


NOTE 1: Share the E-Mails with the CORRECT TEAMDRIVE: $sdname
NOTE 2: SAVE TIME! Copy & Paste the all the E-Mails into the share!"

EOF
cat /psa/var/.emaillist
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
read -rp '↘️  Completed? | Press [ENTER] ' typed < /dev/tty
clonestart

}
