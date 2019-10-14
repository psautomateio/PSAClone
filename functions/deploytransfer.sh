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
executetransport () {

# Reset Front Display
rm -rf  /psa/rclone/deployed.version

# Call Variables
psaclonevars

# to remove all service running prior to ensure a clean launch
ansible-playbook /psa/psaclone/ymls/remove.yml

########################################################### GDRIVE START
echo "gd" > /psa/rclone/deployed.version
type=gd
ansible-playbook /psa/psaclone/ymls/mount.yml -e "\
  bs=$bs
  dcs=$dcs
  dct=$dct
  cma=$cma
  rcs=$rcs
  rcsl=$rcsl
  drive=gd"
########################################################### GDRIVE END

########################################################### SDRIVE END
if [[ "$transport" == "gc" || "$transport" == "sc" || "$transport" == "sd" ]]; then
type=sd
echo "sd" > /psa/rclone/deployed.version
encryptbit=""
ansible-playbook /psa/psaclone/ymls/mount.yml -e "\
  bs=$bs
  dcs=$dcs
  dct=$dct
  cma=$cma
  rcs=$rcs
  rcsl=$rcsl
  cm="writes"
  drive=sd"
fi
########################################################### SDRIVE END

########################################################### ENCRYTPION START
if [[ "$transport" == "gc" || "$transport" == "sc" ]]; then
echo "gc" > /psa/rclone/deployed.version
type=gc
ansible-playbook /psa/psaclone/ymls/crypt.yml -e "\
  bs=$bs
  dcs=$dcs
  dct=$dct
  cma=$cma
  rcs=$rcs
  rcsl=$rcsl
  drive=gc"
fi

if [[ "$transport" == "sc" ]]; then
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
########################################################### ENCRYTPION END

# builds the list
if [[ "$transport" == "sd" || "$transport" == "sc" ]]; then
  ls -la /psa/var/.blitzkeys/ | awk '{print $9}' | tail -n +4 | sort | uniq > /psa/var/.blitzlist
  rm -rf /psa/var/.blitzfinal 1>/dev/null 2>&1
  touch /psa/var/.blitzbuild
  while read p; do
    echo $p > /psa/var/.blitztemp
    blitzcheck=$(grep "GDSA" /psa/var/.blitztemp)
    if [[ "$blitzcheck" != "" ]]; then echo $p >> /psa/var/.blitzfinal; fi
  done </psa/var/.blitzlist
fi

# deploy union
ansible-playbook /psa/psaclone/ymls/psaunity.yml -e "\
  transport=$transport
  encryptbit=$encryptbit
  multihds=$multihds
  type=$type
  dcs=$dcs
  hdpath=$hdpath"

# output final display
if [[ "$type" == "gd" ]]; then finaldeployoutput="GDrive Unencrypted"
elif [[ "$type" == "gc" ]]; then finaldeployoutput="GDrive Encrypted"
elif [[ "$type" == "sd" ]]; then finaldeployoutput="SDrive Unencrypted"
elif [[ "$type" == "sc" ]]; then finaldeployoutput="SDrive Encrypted"; fi
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
💪 DEPLOYED: $finaldeployoutput
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

read -rp '↘️  Acknowledge Info | Press [ENTER] ' typed < /dev/tty

}
