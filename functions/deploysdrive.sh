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
executeblitz () {

# Reset Front Display
rm -rf psautomate/deployed.version

# Call Variables
psaclonevars

# to remove all service running prior to ensure a clean launch
ansible-playbook /psa/psaclone/ymls/remove.yml

# gdrive deploys by standard
type=gd
encryptbit=""
ansible-playbook /psa/psaclone/ymls/mount.yml -e "\
  bs=$bs
  dcs=$dcs
  dct=$dct
  cma=$cma
  rcs=$rcs
  rcsl=$rcsl
  drive=gd"

type=sd
ansible-playbook /psa/psaclone/ymls/mount.yml -e "\
  bs=$bs
  dcs=$dcs
  dct=$dct
  cma=$cma
  rcs=$rcs
  rcsl=$rcsl
  cm="writes"
  drive=sd"

# deploy only if gdrive is using encryption
if [[ "$transport" == "sc" ]]; then
type=gc
ansible-playbook /psa/psaclone/ymls/crypt.yml -e "\
  bs=$bs
  dcs=$dcs
  dct=$dct
  cma=$cma
  rcs=$rcs
  rcsl=$rcsl
  drive=gc"

echo "sc" > /psa/rclone/deployed.version
type=sc
encryptbit="C"
ansible-playbook /psa/psaclone/ymls/crypt.yml -e "\
  bs=$bs
  dcs=$dcs
  dct=$dct
  cma=$cma
  rcs=$rcs
  rcsl=$rcsl
  drive=sc"
fi

# builds the list
ls -la /psa/var/.blitzkeys/ | awk '{print $9}' | tail -n +4 | sort | uniq > /psa/var/.blitzlist
rm -rf /psa/var/.blitzfinal 1>/dev/null 2>&1
touch /psa/var/.blitzbuild
while read p; do
  echo $p > /psa/var/.blitztemp
  blitzcheck=$(grep "GDSA" /psa/var/.blitztemp)
  if [[ "$blitzcheck" != "" ]]; then echo $p >> /psa/var/.blitzfinal; fi
done </psa/var/.blitzlist

# deploy union
ansible-playbook /psa/psaclone/ymls/psaunity.yml -e "\
  transport=$transport \
  type=$type
  multihds=$multihds
  encryptbit=$encryptbit
  dcs=$dcs
  hdpath=$hdpath"

# output final display
if [[ "$type" == "sd" ]]; then finaldeployoutput="SDrive Unencrypted"
else finaldeployoutput="SDrive Encrypted"; fi

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
💪 DEPLOYED: $finaldeployoutput
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

read -rp '↘️  Acknowledge Info | Press [ENTER] ' typed < /dev/tty

}
