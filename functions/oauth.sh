#!/bin/bash
#
# Title:      PSAutomate
# Based On:   PGBlitz (Reference Title File)
# Original Author(s):  Admin9705 - Deiteq
# PSAutomate Auther: fattylewis
# URL:        https://psautomate.io - http://github.psautomate.io
# GNU:        General Public License v3.0
################################################################################
oauth () {
psaclonevars

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Google Auth - ${type} ~ oauth.pgblitz.com
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

https://accounts.google.com/o/oauth2/auth?client_id=$psaclonepublic&redirect_uri=urn:ietf:wg:oauth:2.0:oob&scope=https://www.googleapis.com/auth/drive&response_type=code

Copy & Paste the URL into Browser! Ensure to utilize and login with
the correct Google Account!

PUTTY USERS: Just select and highlight! DO NOT RIGHT CLICK! When you paste
into the browser, it will just work!

Quitting? Type >>> exit
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
  read -p '↘️  Token | PRESS [ENTER]: ' token < /dev/tty
  if [[ "$token" == "exit" || "$token" == "Exit" || "$token" == "EXIT" ]]; then clonestart; fi
  curl --request POST --data "code=$token&client_id=$psaclonepublic&client_secret=$psaclonesecret&redirect_uri=urn:ietf:wg:oauth:2.0:oob&grant_type=authorization_code" https://accounts.google.com/o/oauth2/token > /psa/rclone/psaclone.info

  accesstoken=$(cat /psa/rclone/psaclone.info | grep access_token | awk '{print $2}')
  refreshtoken=$(cat /psa/rclone/psaclone.info | grep refresh_token | awk '{print $2}')
  rcdate=$(date +'%Y-%m-%d')
  rctime=$(date +"%H:%M:%S" --date="$givenDate 60 minutes")
  rczone=$(date +"%:z")
  final=$(echo "${rcdate}T${rctime}${rczone}")

########################
rm -rf /psa/rclone/.${type} 1>/dev/null 2>&1
echo "" > /psa/rclone/.${type}
echo "[$type]" >> /psa/rclone/.${type}
echo "client_id = $psaclonepublic" >> /psa/rclone/.${type}
echo "client_secret = $psaclonesecret" >> /psa/rclone/.${type}
echo "type = drive" >> /psa/rclone/.${type}
echo -n "token = {\"access_token\":${accesstoken}\"token_type\":\"Bearer\",\"refresh_token\":${refreshtoken}\"expiry\":\"${final}\"}" >> /psa/rclone/.${type}
echo "" >> /psa/rclone/.${type}
if [ "$type" == "sd" ]; then
teamid=$(cat /psa/rclone/psaclone.teamid)
echo "team_drive = $teamid" >> /psa/rclone/.sd; fi
echo ""

echo ${type} > /psa/rclone/oauth.check
oauthcheck

## Adds Encryption to the Test Phase if Move or Blitz Encrypted is On
if [[ "$transport" == "sd" || "$transport" == "gc" ]]; then

if [ "$type" == "gd" ]; then entype="gc";
else entype="sc"; fi

PASSWORD=`cat /psa/rclone/psaclone.password`
SALT=`cat /psa/rclone/psaclone.salt`
ENC_PASSWORD=`rclone obscure "$PASSWORD"`
ENC_SALT=`rclone obscure "$SALT"`

rm -rf /psa/rclone/.${entype} 1>/dev/null 2>&1
echo "" >> /psa/rclone/.${entype}
echo "[$entype]" >> /psa/rclone/.${entype}
echo "type = crypt" >> /psa/rclone/.${entype}
echo "remote = $type:/encrypt" >> /psa/rclone/.${entype}
echo "filename_encryption = standard" >> /psa/rclone/.${entype}
echo "directory_name_encryption = true" >> /psa/rclone/.${entype}
echo "password = $ENC_PASSWORD" >> /psa/rclone/.${entype}
echo "password2 = $ENC_SALT" >> /psa/rclone/.${entype};
fi

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎 Process Complete ~ psaclone.psautomate.io
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

💬  [${type}] is now established!

NOTE: If you change projects or use a different login, rerun this again!
If not, nothing will work!

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
read -p '↘️  Acknowledge Info | Press [ENTER] ' typed < /dev/tty
clonestart

}
# (BELOW - SET TEAMDRIVE NAME)##################################################
tlabeloauth () {
psaclonevars
  gtype="https://www.googleapis.com/drive/v3/teamdrives"
  storage="/psa/rclone/teamdrive.output"

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Google Auth - Team Drive Label ~ oauth.psautomate.io
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

https://accounts.google.com/o/oauth2/auth?client_id=${psaclonepublic}&redirect_uri=urn:ietf:wg:oauth:2.0:oob&scope=https://www.googleapis.com/auth/drive&response_type=code

Copy & Paste the URL into Browser! Ensure to utilize and login with
the correct Google Account!

PUTTY USERS: Just select and highlight! DO NOT RIGHT CLICK! When you paste
into the browser, it will just work!

Quitting? Type >>> exit
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
  read -p '↘️  Token | PRESS [ENTER]: ' token < /dev/tty

  if [[ "$token" = "exit" || "$token" == "Exit" || "$token" == "EXIT" ]]; then clonestart; fi
  curl --request POST --data "code=${token}&client_id=${psaclonepublic}&client_secret=${psaclonesecret}&redirect_uri=urn:ietf:wg:oauth:2.0:oob&grant_type=authorization_code" https://accounts.google.com/o/oauth2/token > /psa/var/token.part1
  curl -H "GData-Version: 3.0" -H "Authorization: Bearer $(cat /psa/var/token.part1 | grep access_token | awk '{ print $2 }' | cut -c2- | rev | cut -c3- | rev)" $gtype > $storage

  teamdriveselect
}

teamdriveselect () {
  cat /psa/rclone/teamdrive.output | grep "id" | awk '{ print $2 }' | cut -c2- | rev | cut -c3- | rev > /psa/rclone/teamdrive.id
  cat /psa/rclone/teamdrive.output | grep "name" | awk '{ print $2 }' | cut -c2- | rev | cut -c2- | rev > /psa/rclone/teamdrive.name

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Listed Team Drives
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  A=0
  while read p; do
  ((A++))
  name=$(sed -n ${A}p /psa/rclone/teamdrive.name)
  echo "[$A] $p - $name"
done </psa/rclone/teamdrive.id

if [[ $(cat /psa/rclone/teamdrive.name) == "" ]]; then
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 No Team Drives Exist or Bad Token!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

NOTE1: Create a Team Drive First or Share on to this account and retry the
process again!

NOTE2: If a bad token, ensure that you are using the correct account when
signing in (and/or conducting a proper copy and paste of the token)!

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
read -p '↘️  Acknowlege Info | Press [ENTER] ' typed < /dev/tty
clonestart
fi

echo ""
read -p '↘️  Type Number | Press [ENTER]: ' typed < /dev/tty
if [[ "$typed" -ge "1" && "$typed" -le "$A" ]]; then a=b
else teamdriveselect; fi

  name=$(sed -n ${typed}p /psa/rclone/teamdrive.name)
  id=$(sed -n ${typed}p /psa/rclone/teamdrive.id)
  echo "$name" > /psa/rclone/psaclone.teamdrive
  echo "$id" > /psa/rclone/psaclone.teamid

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Process Complete! TeamDrive [$name]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

NOTE: Do not share out your teamdrives to others! The usage counts against
you and if others share your content, you have no control (and your team
drive can be shutdown!)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
  read -p '↘️  Acknowledge Info | PRESS [ENTER] ' temp < /dev/tty
}

mountchecker () {
psaclonevars
  if [[ "$transport" == "gd" ]]; then
    if [[ "$gdstatus" != "ACTIVE" ]]; then mountfail; fi
elif [[ "$transport" == "gc" ]]; then
  if [[ "$gdstatus" != "ACTIVE" || "$gcstatus" != "ACTIVE" ]]; then mountfail; fi
elif [[ "$transport" == "sd" ]]; then
  if [[ "$gdstatus" != "ACTIVE" || "$sdstatus" != "ACTIVE" ]]; then mountfail; fi
elif [[ "$transport" == "sd" ]]; then
  if [[ "$gdstatus" != "ACTIVE" || "$sdstatus" != "ACTIVE" || "$sdstatus" != "ACTIVE" || "$scstatus" != "ACTIVE" ]]; then mountfail; fi
fi
}

mountfail () {
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎 Fail Notice ~ psaclone.psautomate.io
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

💬  All Mounts Must Be Active!

NOTE: If any mount says [NOT-SET]; that process must be completed first!
We will continue to block this process until completed!

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
read -p '↘️  Acknowledge Info | Press [ENTER] ' typed < /dev/tty
clonestart
}

tlabelchecker () {
psaclonevars
if [[ "$sdname" == "NOT-SET" ]]; then

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎 Fail Notice ~ oauth.psautomate.io
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

💬  Team Drive Label Not Set!

NOTE: Unless we know your Team Drive name, we have no way of configuring
the Team Drive! Please complete this first!

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
read -p '↘️  Acknowledge Info | Press [ENTER] ' typed < /dev/tty
clonestart
fi
}
