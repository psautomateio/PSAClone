#!/bin/bash
#
# Title:      PSAutomate
# Based On:   PGBlitz (Reference Title File)
# Original Author(s):  Admin9705 - Deiteq
# PSAutomate Auther: fattylewis
# URL:        https://psautomate.io - http://github.psautomate.io
# GNU:        General Public License v3.0
################################################################################
psaclonevars () {

  variablet () {
    file="$1"
    if [ ! -e "$file" ]; then touch "$1"; fi
  }

  # rest standard
  mkdir -p /psa/logs /psa/rclone
  touch /psa/logs/gd.log /psa/logs/sd.log /psa/logs/ge.log /psa/logs/se.log /psa/logs/psablitz.log /psa/logs/transport.log

  variable /psa/var/project.account "NOT-SET"
  variable /psa/rclone/deploy.version "null"
  variable /psa/rclone/psaclone.transport "NOT-SET"
  variable /psa/var/move.bw  "9"
  variable /psa/var/blitz.bw  "1000"
  variable /psa/rclone/psaclone.salt ""
  variable /psa/var/multihd.paths ""

  variable /psa/var/server.hd.path "/pg"
  hdpath=$(cat /psa/var/server.hd.path)

  variable /psa/rclone/oauth.check ""
  oauthcheck=$(cat /psa/rclone/oauth.check)

  variable /psa/rclone/psaclone.password "NOT-SET"
  if [[ $(cat /psa/rclone/psaclone.password) == "NOT-SET" ]]; then pstatus="NOT-SET"
  else
    pstatus="ACTIVE"
    clonepassword=$(cat /psa/rclone/psaclone.password)
    clonesalt=$(cat /psa/rclone/psaclone.salt)
  fi

  variable /psa/rclone/.gd "NOT-SET"
  if [[ $(cat /psa/rclone/.gd) == "NOT-SET" ]]; then gdstatus="NOT-SET"
  else gdstatus="ACTIVE"; fi

  variable /psa/rclone/.sd "NOT-SET"
  if [[ $(cat /psa/rclone/.sd) == "NOT-SET" ]]; then sdstatus="NOT-SET"
  else sdstatus="ACTIVE"; fi

  variable /psa/rclone/.sc "NOT-SET"
  if [[ $(cat /psa/rclone/.sc) == "NOT-SET" ]]; then scstatus="NOT-SET"
  else scstatus="ACTIVE"; fi

  variable /psa/rclone/.gc "NOT-SET"
  if [[ $(cat /psa/rclone/.gc) == "NOT-SET" ]]; then gcstatus="NOT-SET"
  else gcstatus="ACTIVE"; fi

  transport=$(cat /psa/rclone/psaclone.transport)

  variable /psa/rclone/psaclone.teamdrive "NOT-SET"
  sdname=$(cat /psa/rclone/psaclone.teamdrive)

  variable /psa/rclone/psaclone.demo "OFF"
  demo=$(cat /psa/rclone/psaclone.demo)

  variable /psa/rclone/psaclone.teamid ""
  sdid=$(cat /psa/rclone/psaclone.teamid)

  variable /psa/rclone/deploy.version ""
  type=$(cat /psa/rclone/deploy.version)

  variable /psa/rclone/psaclone.public ""
  psaclonepublic=$(cat /psa/rclone/psaclone.public)

  mkdir -p /psa/var/.blitzkeys
  displaykey=$(ls /psa/var/.blitzkeys | wc -l)

  variable /psa/rclone/psaclone.secret ""
  psaclonesecret=$(cat /psa/rclone/psaclone.secret)

  if [[ "$psaclonesecret" == "" || "$psaclonepublic" == "" ]]; then psacloneid="NOT-SET"; fi
  if [[ "$psaclonesecret" != "" && "$psaclonepublic" != "" ]]; then psacloneid="ACTIVE"; fi

  variable /psa/rclone/psaclone.email "NOT-SET"
  psacloneemail=$(cat /psa/rclone/psaclone.email)

  variable /psa/var/oauth.type "NOT-SET" #output for auth type
  oauthtype=$(cat /psa/var/oauth.type)

  variable /psa/rclone/psaclone.project "NOT-SET"
  psacloneproject=$(cat /psa/rclone/psaclone.project)

  variable /psa/rclone/deployed.version ""
  dversion=$(cat /psa/rclone/deployed.version)

  variablet /psa/var/.tmp.multihd
  multihds=$(cat /psa/var/.tmp.multihd)

  if [[ "$dversion" == "gd" ]]; then dversionoutput="GDrive Unencrypted"
elif [[ "$dversion" == "gc" ]]; then dversionoutput="GDrive Encrypted"
elif [[ "$dversion" == "sd" ]]; then dversionoutput="SDrive Unencrypted"
elif [[ "$dversion" == "sc" ]]; then dversionoutput="SDrive Encrypted"
elif [[ "$dversion" == "le" ]]; then dversionoutput="Local HD/Mount"
else dversionoutput="None"; fi

# For Clone Clean
  variable /psa/var/cloneclean "600"
  cloneclean=$(cat /psa/var/cloneclean)

# Copy JSON if Missing
  if [ ! -e "/psa/rclone/psaclone.json" ]; then cp /psa/psaclone/psaclone.json /psa/rclone/psaclone.json; fi

# For PSA Blitz Mounts
  bs=$(jq -r '.bs' /psa/rclone/psaclone.json)
  dcs=$(jq -r '.dcs' /psa/rclone/psaclone.json)
  dct=$(jq -r '.dct' /psa/rclone/psaclone.json)
  cma=$(jq -r '.cma' /psa/rclone/psaclone.json)
  rcs=$(jq -r '.rcs' /psa/rclone/psaclone.json)
  rcsl=$(jq -r '.rcsl' /psa/rclone/psaclone.json)
  cm=$(jq -r '.cm' /psa/rclone/psaclone.json)
  cms=$(jq -r '.cms' /psa/rclone/psaclone.json)

  randomagent=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 16 | head -n 1)
  variable /psa/var/uagent "$randomagent"
  uagent=$(cat /psa/var/uagent)
}
