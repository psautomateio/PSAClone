#!/bin/bash
#
# Title:      PSAutomate
# Based On:   PGBlitz (Reference Title File)
# Original Author(s):  Admin9705 - Deiteq
# PSAutomate Auther: fattylewis
# URL:        https://psautomate.io - http://github.psautomate.io
# GNU:        General Public License v3.0
################################################################################
bandwidth () {
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 System Message: BW Limit Notice        📓 Reference: move.psautomate.io
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

💬 10MB is a safe limit. If exceeding 10MB and uploading straight for
24 hours, an upload ban will be triggered.

EOF
  read -p '↘️  Type a Speed from 1 - 1000 | Press [ENTER]: ' typed < /dev/tty
  if [[ "$typed" -ge "1" && "$typed" -le "1000" ]]; then echo "$typed" > /psa/var/move.bw && question1;
  else badinput && bandwidth; fi
}

bandwidthblitz () {
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 System Message: BW Limit Notice        📓 Reference: move.psautomate.io
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

💬 100MB = 1 Gig Speeds | 1000MB = 10 Gig Speeds - Remember that your
   upload speeds are still limited to your server's max upload connection

EOF
  read -p '↘️  Type a Speed from 1 - 1000 | Press [ENTER]: ' typed < /dev/tty
  if [[ "$typed" -ge "1" && "$typed" -le "1000" ]]; then echo "$typed" > /psa/var/blitz.bw && question1;
  else badinput && bandwidth; fi
}

statusmount () {
  mcheck5=$(cat /psa/rclone/psablitz.conf | grep "$type")
  if [ "$mcheck5" != "" ]; then
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⚠️  System Message: Warning!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
NOTE: $type already exists! To proceed, we must delete the prior
configuration for you.

EOF
  read -p '↘️  Proceed? y or n | Press [ENTER]: ' typed < /dev/tty

  if [[ "$typed" == "Y" || "$typed" == "y" ]]; then a=b
elif [[ "$typed" == "N" || "$typed" == "n" ]]; then mountsmenu
  else
    badinput
    statusmount
  fi

  rclone config delete $type --config /psa/rclone/psablitz.conf

  encheck=$(cat /psa/rclone/psaclone.transport)
  if [[ "$encheck" == "sc" || "$encheck" == "gc" ]]; then
    if [ "$type" == "gc" ]; then
    rclone config delete gcrypt --config /psa/rclone/psablitz.conf; fi
    if [ "$type" == "sd" ]; then
    rclone config delete scrypt --config /psa/rclone/psablitz.conf; fi
  fi

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 System Message: $type deleted!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
read -p '↘️  Acknowledge Info | Press [ENTER] ' typed < /dev/tty
fi
}

tmgen() {

secret=$(cat /psa/rclone/psaclone.secret)
public=$(cat /psa/rclone/psaclone.public)

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Google Auth - Shared Drives | 📓 Reference: oauth.psautomate.io
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Quitting? Type > exit
NOTE: Copy & Paste Url into Browser | Use Correct Google Account!

https://accounts.google.com/o/oauth2/auth?client_id=$public&redirect_uri=urn:ietf:wg:oauth:2.0:oob&scope=https://www.googleapis.com/auth/drive&response_type=code

EOF
  read -p '↘️  Token | PRESS [ENTER]: ' token < /dev/tty
  if [ "$token" = "exit" ]; then mountsmenu; fi
  curl --request POST --data "code=$token&client_id=$public&client_secret=$secret&redirect_uri=urn:ietf:wg:oauth:2.0:oob&grant_type=authorization_code" https://accounts.google.com/o/oauth2/token > /psa/var/psatokentm.output
  cat /psa/var/psatokentm.output | grep access_token | awk '{ print $2 }' | cut -c2- | rev | cut -c3- | rev > /psa/var/psatokentm2.output
  primet=$(cat /psa/var/psatokentm2.output)
  curl -H "GData-Version: 3.0" -H "Authorization: Bearer $primet" https://www.googleapis.com/drive/v3/teamdrives > /psa/rclone/teamdrive.output
  tokenscript

  name=$(sed -n ${typed}p /psa/rclone/teamdrive.name)
  id=$(sed -n ${typed}p /psa/rclone/teamdrive.id)
echo "$name" > /psa/rclone/psaclone.teamdrive
echo "$id" > /psa/rclone/psaclone.teamid
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
😂 What a Lame Shared Drive Name: $name
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  read -p '↘️  Acknowledge Info | PRESS [ENTER] ' temp < /dev/tty
}

tokenscript () {
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

echo ""
read -p '↘️  Type Number | PRESS [ENTER]: ' typed < /dev/tty
if [[ "$typed" -ge "1" && "$typed" -le "$A" ]]; then a=b
else
  badinput
  tokenscript; fi
}

inputphase () {
deploychecks

if [[ "$transport" == "PG Move /w No Encryption" || "$transport" == "PG Move /w Encryption" ]]; then
  display=""
else
  if [ "$type" == "sd" ]; then
  display="TEAMDRIVE: $teamdrive
  ";fi; fi

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 System Message: PG Clone - $type     📓 Reference: oauth.psautomate.io
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
💬 PG is Deploying /w the Following Values:

🌅 ID
$public

💎 SECRET
$secret
$display
EOF

read -p '↘️  Proceed? y or n | Press [ENTER]: ' typed < /dev/tty

if [[ "$typed" == "Y" || "$typed" == "y" ]]; then a=b
elif [[ "$typed" == "N" || "$typed" == "n" ]]; then question1
else
  badinput
  inputphase
fi

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 System Message: Google Auth          📓 Reference: oauth.psautomate.io
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Quitting? Type > exit
NOTE: Copy & Paste Url into Browser | Use Correct Google Account!

https://accounts.google.com/o/oauth2/auth?client_id=$public&redirect_uri=urn:ietf:wg:oauth:2.0:oob&scope=https://www.googleapis.com/auth/drive&response_type=code

EOF
  read -p '↘️  Token | PRESS [ENTER]: ' token < /dev/tty
  if [ "$token" = "exit" ]; then mountsmenu; fi
  curl --request POST --data "code=$token&client_id=$public&client_secret=$secret&redirect_uri=urn:ietf:wg:oauth:2.0:oob&grant_type=authorization_code" https://accounts.google.com/o/oauth2/token > /psa/rclone/psaclone.info

  accesstoken=$(cat /psa/rclone/psaclone.info | grep access_token | awk '{print $2}')
  refreshtoken=$(cat /psa/rclone/psaclone.info | grep refresh_token | awk '{print $2}')
  rcdate=$(date +'%Y-%m-%d')
  rctime=$(date +"%H:%M:%S" --date="$givenDate 60 minutes")
  rczone=$(date +"%:z")
  final=$(echo "${rcdate}T${rctime}${rczone}")

  testphase
}

mountsmenu () {

# Sets Display Status if Passwords are not set for the encryhpted edition
check5=$(cat /psa/rclone/psaclone.password)
check6=$(cat /psa/rclone/psaclone.salt)
if [[ "$check5" == "" || "$check6" == "" ]]; then passdisplay="⚠️  Not Activated"
else passdisplay="✅ Activated"; fi

projectid=$(cat /psa/rclone/psaclone.project)
secret=$(cat /psa/rclone/psaclone.secret)
public=$(cat /psa/rclone/psaclone.public)
teamdrive=$(cat /psa/rclone/psaclone.teamdrive)

if [ "$secret" == "" ]; then dsecret="NOT SET"; else dsecret="SET"; fi
if [ "$public" == "" ]; then dpublic="NOT SET"; else dpublic="SET"; fi
if [ "$teamdrive" == "" ]; then dteamdrive="NOT SET"; else dteamdrive=$teamdrive; fi

gdstatus=$(cat /psa/var/gd.psaclone)
sdstatus=$(cat /psa/var/sd.psaclone)

###### START
if [ "$transport" == "PG Move /w No Encryption" ]; then
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎 PG Clone - OAuth & Mounts          📓 Reference: psaclone.psautomate.io
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

💾 OAuth
[1] Client ID: $dpublic
[2] Secret ID: ${dsecret}

📁 RClone Configuration
[3] gdrive   : $gdstatus
[Z] Exit

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

  read -p '↘️  Set Choice | Press [ENTER]: ' typed < /dev/tty

  if [ "$typed" == "1" ]; then
    publickeyinput
    mountsmenu
  elif [ "$typed" == "2" ]; then
    secretkeyinput
    mountsmenu
  elif [ "$typed" == "3" ]; then
    type=gdrive
    statusmount
    inputphase
    mountsmenu
  elif [[ "$typed" == "Z" || "$typed" == "z" ]]; then question1;
  else badinput
    mountsmenu; fi
fi
########## END

########## START
if [ "$transport" == "PG Move /w Encryption" ]; then
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎 PG Clone - OAuth & Mounts          📓 Reference: psaclone.psautomate.io
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

💾 OAuth
[1] Client ID: $dpublic
[2] Secret ID: ${dsecret}

💡 Required Tasks
[3] Passwords: $passdisplay

📁 RClone Configuration
[4] gdrive   : $gdstatus
[Z] Exit

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

  read -p '↘️  Set Choice | Press [ENTER]: ' typed < /dev/tty

  if [ "$typed" == "1" ]; then
    publickeyinput
    mountsmenu
  elif [ "$typed" == "2" ]; then
    secretkeyinput
    mountsmenu
  elif [ "$typed" == "3" ]; then
    blitzpasswords
    mountsmenu
  elif [ "$typed" == "4" ]; then
    encpasswdcheck
    type=gdrive
    statusmount
    inputphase
    mountsmenu
  elif [[ "$typed" == "Z" || "$typed" == "z" ]]; then question1;
  else badinput
    mountsmenu; fi
fi
###### END

###### START
if [ "$transport" == "PG Blitz /w No Encryption" ]; then
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎 PG Clone - OAuth & Mounts          📓 Reference: psaclone.psautomate.io
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

💾 OAuth
[1] Client ID: $dpublic
[2] Secret ID: ${dsecret}

💡 Required Tasks
[3] TD Label : $dteamdrive

📁 RClone Configuration
[4] gdrive   : $gdstatus
[5] sdrive   : $sdstatus
[Z] Exit

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

read -p '↘️  Set Choice | Press [ENTER]: ' typed < /dev/tty

if [ "$typed" == "1" ]; then
  publickeyinput
  mountsmenu
elif [ "$typed" == "2" ]; then
  secretkeyinput
  mountsmenu
elif [ "$typed" == "3" ]; then
  tmgen
  mountsmenu
elif [ "$typed" == "4" ]; then
  type=gdrive
  statusmount
  inputphase
  mountsmenu
elif [ "$typed" == "5" ]; then
  tmcheck=$(cat /psa/rclone/psaclone.teamdrive)
  if [ "$tmcheck" == "" ]; then
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔ Warning! TeamDrive is blank! Must be Set Prior!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  read -p '↘️  Acknowledge Info | Press [ENTER] ' typed < /dev/tty
  mountsmenu; fi
  type=sdrive
  statusmount
  inputphase
  mountsmenu
elif [[ "$typed" == "Z" || "$typed" == "z" ]]; then question1;
else badinput
  mountsmenu; fi
fi
#################### END

##### START
if [ "$transport" == "PG Blitz /w Encryption" ]; then
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎 PG Clone - OAuth & Mounts          📓 Reference: psaclone.psautomate.io
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

💾 OAuth
[1] Client ID: $dpublic
[2] Secret ID: ${dsecret}

💡 Required Tasks
[3] TD Label : $dteamdrive
[4] Passwords: $passdisplay

📁 RClone Configuration
[5] gdrive   : $gdstatus
[6] sdrive   : $sdstatus
[Z] Exit

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

read -p '↘️  Set Choice | Press [ENTER]: ' typed < /dev/tty

if [ "$typed" == "1" ]; then
  publickeyinput
  mountsmenu
elif [ "$typed" == "2" ]; then
  secretkeyinput
  mountsmenu
elif [ "$typed" == "3" ]; then
  tmgen
  mountsmenu
elif [ "$typed" == "4" ]; then
  blitzpasswords
  mountsmenu
elif [ "$typed" == "5" ]; then
  encpasswdcheck
  type=gdrive
  statusmount
  inputphase
  mountsmenu
elif [ "$typed" == "6" ]; then
  encpasswdcheck
  tmcheck=$(cat /psa/rclone/psaclone.teamdrive)
  if [ "$tmcheck" == "" ]; then
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔ Warning! TeamDrive is blank! Must be Set Prior!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  read -p '↘️  Acknowledge Info | Press [ENTER] ' typed < /dev/tty
  mountsmenu; fi
  type=sdrive
  statusmount
  inputphase
  mountsmenu
elif [[ "$typed" == "Z" || "$typed" == "z" ]]; then question1;
else badinput
  mountsmenu; fi
fi
#################### END

}

encpasswdcheck () {
check5=$(cat /psa/rclone/psaclone.password)
check6=$(cat /psa/rclone/psaclone.salt)

if [[ "$check5" == "" || "$check6" == "" ]]; then
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔ Warning! You Need to Setup Your Passwords for the Encrypted Edition
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  read -p '↘️  Acknowledge Info | Press [ENTER] ' typed < /dev/tty
  mountsmenu; fi
}

blitzpasswords () {
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎 Primary Password                   📓 Reference: psaclone.psautomate.io
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Quitting? Type > Exit

Please set a Primary Password for Encryption! Do not forget it! If you do,
you will be locked out from all your data!

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
read -p ' ↘️  Type Prime PW | Press [ENTER]: ' bpassword < /dev/tty

if [ "$bpassword" == "" ]; then
  badinput
  blitzpasswords
elif [ "$bpassword" == "exit" ]; then mountsmenu; fi
blitzsalt
}

blitzsalt () {
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎 SALT (Secondary Password)          📓 Reference: psaclone.psautomate.io
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Quitting? Type > Exit

Please set a Secondary Password (SALT) for Encryption! Do not forget it!
If you do, you will be locked out from all your data!  SALT randomizes
your data to further protect you! It is not recommended to use the same
password, but may.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
read -p ' ↘️  Type SALT PW | Press [ENTER]: ' bsalt < /dev/tty

if [ "$bsalt" == "" ]; then
  badinput
  blitzsalt
elif [ "$bsalt" == "exit" ]; then mountsmenu; fi
blitzpfinal

}

blitzpfinal () {
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎 Set Passwords?                     📓 Reference: psaclone.psautomate.io
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Quitting? Type > Exit

Are you happy with the following info? Type y or n!

Primary  : $bpassword
Secondary: $bsalt

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

read -p '↘️  Type y or n | Press [ENTER]: ' typed < /dev/tty

if [ "$typed" == "n" ]; then mountsmenu;
elif [ "$typed" == "y" ]; then
echo $bpassword > /psa/rclone/psaclone.password
echo $bsalt > /psa/rclone/psaclone.salt
mountsmenu;
else
  badinput
  blitzpfinal; fi
}

publickeyinput () {
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Google OAuth Keys - Client ID        📓 Reference: oauth.psautomate.io
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Quitting? Type > exit
NOTE: Visit reference for Google OAuth Keys!

EOF

read -p '↘️  Client ID  | Press [Enter]: ' public < /dev/tty
if [ "$public" = "exit" ]; then mountsmenu; fi
echo "$public" > /psa/rclone/psaclone.public

tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎 Client ID Set                      📓 Reference: psaclone.psautomate.io
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
read -p '↘️  Acknowledge Info  | Press [ENTER] ' public < /dev/tty
mountsmenu
}

secretkeyinput () {
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Google OAuth Keys - Secret Key       📓 Reference: oauth.psautomate.io
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Quitting? Type > exit
NOTE: Visit reference for Google OAuth Keys!

EOF
read -p '↘️  Secret Key  | Press [Enter]: ' secret < /dev/tty
if [ "$secret" = "exit" ]; then mountsmenu; fi
echo "$secret" > /psa/rclone/psaclone.secret

tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎 Secret ID Set                       📓 Reference: psaclone.psautomate.io
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
read -p '↘️  Acknowledge Info  | Press [ENTER] ' public < /dev/tty

mountsmenu
}

projectmenu () {
projectid=$(cat /psa/rclone/psaclone.project)

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎 GCloud Project Interface           📓 Reference: psaclone.psautomate.io
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Project ID: $projectid

[1] Establish
[2] Create
[3] Destroy (NOT READY)
[Z] Exit

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

read -p '↘️  Set Choice | Press [ENTER]: ' typed < /dev/tty

if [ "$typed" == "1" ]; then projectestablish;
elif [ "$typed" == "2" ]; then projectcreate;
elif [[ "$typed" == "z" || "$typed" == "Z" ]]; then question1;
else badinput
  projectmenu; fi
}

projectestablish () {

  gcloud projects list > /psa/var/projects.list
  projectcheck=(cat /psa/var/projects.list)
  if [ "$projectcheck" == "" ]; then
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔  System Message: Error! There are no projects! Make one first!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  read -p ' ↘️  Acknowledge Info | Press [ENTER] ' typed < /dev/tty
  projectmenu
fi


tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎 Established Projects               📓 Reference: psaclone.psautomate.io
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Project ID: $projectid

EOF
  cat /psa/var/projects.list | cut -d' ' -f1 | tail -n +2
  cat /psa/var/projects.list | cut -d' ' -f1 | tail -n +2 > /psa/var/project.cut
  echo
  changeproject
  echo
  projectidset
  gcloud config set project $typed

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎 System Message: Enabling Drive API ~ Project $typed
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
gcloud services enable drive.googleapis.com --project $typed
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎 System Message: Project Established ~ $typed
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  echo $typed > /psa/rclone/psaclone.project
  read -p '↘️  Acknowledge Info | Press [ENTER] ' typed < /dev/tty
  projectmenu

}

transportdisplay () {
temp=$(cat /psa/rclone/psaclone.transport)
  if [ "$temp" == "gd" ]; then transport="GDrive Unencrypted"
elif [ "$temp" == "gc" ]; then transport="GDrive Encrypted"
elif [ "$temp" == "sd" ]; then transport="SDrive Unencrypted"
elif [ "$temp" == "sc" ]; then transport="SDrive Encrypted"
elif [ "$temp" == "solohd" ]; then transport="PG Local"
else transport="NOT-SET"; fi
}

transportmode () {
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌟 Select Transport Mode            📓 Reference: transport.psautomate.io
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[1] GDrive Unencrypted | Upload 750GB Daily ~ Simple
[2] GDrive Encrypted   | Upload 750GB Daily ~ Simple
[3] SDrive Unencrypted | Exceed 750GB Daily ~ Complex
[4] SDrive Encrypted   | Exceed 750GB Daily ~ Complex
[5] PG Local           | No GSuite - Stays Local
[Z] Exit

EOF
read -p '↘️  Set Choice | Press [ENTER]: ' typed < /dev/tty

  if [ "$typed" == "1" ]; then echo "gd" > /psa/rclone/psaclone.transport && echo;
elif [ "$typed" == "2" ]; then echo "gc" > /psa/rclone/psaclone.transport && echo;
elif [ "$typed" == "3" ]; then echo "sd" > /psa/rclone/psaclone.transport && echo;
elif [ "$typed" == "4" ]; then echo "sc" > /psa/rclone/psaclone.transport && echo;
elif [ "$typed" == "5" ]; then echo "solohd" > /psa/rclone/psaclone.transport && echo;
elif [[ "$typed" == "Z" || "$typed" == "z" ]]; then

# If a New Installer, User Cannot Exit & Must Select a Version
transport=$(cat /psa/rclone/psaclone.transport)
if [ "$transport" == "NOT-SET" ]; then
transportmode; fi

question1;
else
  badinput
  transportmode; fi
}

changeproject () {
  read -p '💬 Set/Change Project ID? (y/n)| Press [ENTER] ' typed < /dev/tty
  if [[ "$typed" == "n" || "$typed" == "N" ]]; then question1
elif [[ "$typed" == "y" || "$typed" == "Y" ]]; then a=b
else badinput
  echo ""
  changeproject; fi
}

projectidset () {
tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 System Message: Type the Project Name to Utilize
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  cat /psa/var/projects.list | cut -d' ' -f1 | tail -n +2
  cat /psa/var/projects.list | cut -d' ' -f1 | tail -n +2 > /psa/var/project.cut
  echo ""
  read -p '↘️  Type Project Name | Press [ENTER]: ' typed < /dev/tty
  echo ""
  list=$(cat /psa/var/project.cut | grep $typed)

  if [ "$typed" != "$list" ]; then
tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔  System Message: Error! Type Exact of the Project Name Listed!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  read -p ' ↘️  Acknowledge Info | Press [ENTER] ' typed < /dev/tty
  projectidset
  fi
}

testphase () {
  echo "" > /psa/rclone/test.conf
  echo "[$type]" >> /psa/rclone/test.conf
  echo "client_id = $public" >> /psa/rclone/test.conf
  echo "client_secret = $secret" >> /psa/rclone/test.conf
  echo "type = drive" >> /psa/rclone/test.conf
  echo -n "token = {\"access_token\":${accesstoken}\"token_type\":\"Bearer\",\"refresh_token\":${refreshtoken}\"expiry\":\"${final}\"}" >> /psa/rclone/test.conf
  echo "" >> /psa/rclone/test.conf
  if [ "$type" == "sd" ]; then
  teamid=$(cat /psa/rclone/psaclone.teamid)
  echo "team_drive = $teamid" >> /psa/rclone/test.conf; fi
  echo ""

## Adds Encryption to the Test Phase if Move or Blitz Encrypted is On
encheck=$(cat /psa/rclone/psaclone.transport)
if [[ "$encheck" == "sc" || "$encheck" == "gc" ]]; then

  if [ "$type" == "gdrive" ]; then entype="gcrypt";
  else entype="scrypt"; fi

  PASSWORD=`cat /psa/rclone/psaclone.password`
  SALT=`cat /psa/rclone/psaclone.salt`
  ENC_PASSWORD=`rclone obscure "$PASSWORD"`
  ENC_SALT=`rclone obscure "$SALT"`
  echo "" >> /psa/rclone/test.conf
  echo "[$entype]" >> /psa/rclone/test.conf
  echo "type = crypt" >> /psa/rclone/test.conf
  echo "remote = $type:/encrypt" >> /psa/rclone/test.conf
  echo "filename_encryption = standard" >> /psa/rclone/test.conf
  echo "directory_name_encryption = true" >> /psa/rclone/test.conf
  echo "password = $ENC_PASSWORD" >> /psa/rclone/test.conf
  echo "password2 = $ENC_SALT" >> /psa/rclone/test.conf;

fi
testphase2
}

testphase2 () {
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 System Message: Conducting Validation Checks - $type
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
  sleep 1
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 System Message: Creating Test Directory - $type:/psautomate
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
  sleep 1
  rclone mkdir --config /psa/rclone/test.conf $type:/psautomate
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 System Message: Checking Existance of $type:/psautomate
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
  rcheck=$(rclone lsd --config /psa/rclone/test.conf $type: | grep -oP psautomate | head -n1)

  if [ "$rcheck" != "psautomate" ];then
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔  System Message: Validation Checks Failed
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

TIPS:
1. Did you copy your username and password correctly?
2. When you created the credentials, did you select "Other"?
3. Did you enable your API?

FOR ENCRYPTION (IF SELECTED)
1. Did You Set a Password?

EOF
    echo "⚠️  Not Activated" > /psa/var/$type.psaclone
    read -p '↘️  Acknowledge Info | Press [ENTER] ' typed2 < /dev/tty
    question1
else
tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 System Message: Validation Checks Passed - $type
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF

fi

read -p '↘️  Acknowledge Info | Press [ENTER] ' typed2 < /dev/tty
echo "✅ Activated" > /psa/var/$type.psaclone

## Copy the Test File to the Real RClone Conf
cat /psa/rclone/test.conf >> /psa/rclone/psablitz.conf

## Back to the Main Mount Menu
mountsmenu

EOF
}

deploychecks () {
secret=$(cat /psa/rclone/psaclone.secret)
public=$(cat /psa/rclone/psaclone.public)
teamdrive=$(cat /psa/rclone/psaclone.teamdrive)

if [ "$secret" == "" ]; then
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔  ERROR: Secret Key Is Blank! Unable to Deploy!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
read -p '↘️  Acknowledge Info | Press [Enter] ' typed < /dev/tty
question1; fi

if [ "$public" == "" ]; then
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔  ERROR: Client ID Is Blank! Unable to Deploy!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
read -p '↘️  Acknowledge Info | Press [Enter] ' typed < /dev/tty
question1; fi
}
