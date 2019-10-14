#!/bin/bash
#
# Title:      PSAutomate
# Based On:   PGBlitz (Reference Title File)
# Original Author(s):  Admin9705 - Deiteq
# PSAutomate Auther: fattylewis
# URL:        https://psautomate.io - http://github.psautomate.io
# GNU:        General Public License v3.0
################################################################################
projectname () {
psaclonevars

############## REMINDERS
# Make destroying piece quiet and create a manual delete confirmatino
# When user creates project, give them the option to switch
# fix existing set project

############## REMINDERS

# prevents user from moving on unless email is set
if [[ "$psacloneemail" == "NOT-SET" ]]; then
echo
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
read -p '↘️  ERROR! E-Mail is not setup! | Press [ENTER] ' typed < /dev/tty
clonestart; fi

projectcheck="good"
if [[ $(gcloud projects list --account=${psacloneemail} | grep "pg-") == "" ]]; then
projectcheck="bad"; fi

# prompt user
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 PG Clone - Project ~ psaclone.psautomate.io
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

CURRENT PROJECT: $psacloneproject

[1] Project: Use Existing Project
[2] Project: Build New & Set Project
[3] Project: Destroy
[Z] Exit

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
read -p '↘️  Input Value | Press [Enter]: ' typed < /dev/tty

case $typed in
1 )
    if [[ "$projectcheck" == "bad" ]]; then
    echo "BAD"
    clonestart
  elif [[ "$projectcheck" == "good" ]]; then
    exisitingproject; fi ;;
2 )
    projectnameset
    buildproject ;;

3 )
    destroyproject ;;
Z )
    clonestart ;;
z )
    clonestart ;;
* )
    keyinputpublic ;;
esac

}

exisitingproject () {
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 PG Clone - Existing Project ~ psaclone.psautomate
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
projectlist
tee <<-EOF

Qutting? Type >>> Exit
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
read -p '↘️  Use Which Existing Project? | Press [ENTER]: ' typed < /dev/tty
if [[ "$typed" == "Exit" || "$typed" == "exit" || "$typed" == "EXIT" ]]; then clonestart; fi

# Repeats if Users Fails the Range
if [[ "$typed" -ge "1" && "$typed" -le "$pnum" ]]; then
existingnumber=$(cat /psa/var/prolist/$typed)

echo
gcloud config set project ${existingnumber} --account=${psacloneemail}

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 PG Clone - Enabling Your API (Standby) ~ psaclone.psautomate.io
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
gcloud services enable drive.googleapis.com --project ${existingnumber} --account=${psacloneemail}
else exisitingproject; fi
echo
read -p '↘️  Existing Project Set | Press [ENTER] ' typed < /dev/tty
echo "${existingnumber}" > /psa/rclone/psaclone.project
clonestart
}

destroyproject () {
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 PG Clone - Destroy Project ~ psaclone.psautomate.io
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
projectlist
tee <<-EOF

Qutting? Type >>> Exit
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
read -p '↘️  Destroy Which Project? | Press [ENTER]: ' typed < /dev/tty
if [[ "$typed" == "Exit" || "$typed" == "exit" || "$typed" == "EXIT" ]]; then optionsmenu; fi

# Repeats if Users Fails the Range
if [[ "$typed" -ge "1" && "$typed" -le "$pnum" ]]; then
destroynumber=$(cat /psa/var/prolist/$typed)

  # Cannot Destroy Active Project
  if [[ $(cat /psa/rclone/psaclone.project) == "$destroynumber" ]]; then
  echo
  read -p '↘️  Unable to Destroy an Active Project | Press [ENTER] ' typed < /dev/tty
  destroyproject
  fi

echo
gcloud projects delete ${destroynumber} --account=${psacloneemail}
else destroyproject; fi
echo
read -p '↘️  Project Deleted | Press [ENTER] ' typed < /dev/tty
optionsmenu
}

projectlist () {
pnum=0
mkdir -p /psa/var/prolist
rm -rf /psa/var/prolist/* 1>/dev/null 2>&1

gcloud projects list --account=${psacloneemail} | tail -n +2 | awk '{print $1}' > /psa/var/prolist/prolist.sh

while read p; do
  let "pnum++"
  echo "$p" > "/psa/var/prolist/$pnum"
  echo "[$pnum] $p" >> /psa/var/prolist/final.sh
  echo "[$pnum] ${filler}${p}"
done </psa/var/prolist/prolist.sh
}

projectnamecheck () {

psaclonevars
if [[ "$psacloneproject" == "NOT-SET" ]]; then
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎 Fail Notice ~ psaclone.psautomate.io
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

💬  The PROJECT must be set first!

NOTE: Without setting a project, PSA Blitz is unable to establish, build
keys, and deploy the proper GDSA Accounts for the Team Drive

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

read -p '↘️  Acknowledge Info | Press [ENTER] ' typed < /dev/tty
clonestart
fi

}

projectnameset () {

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 PG Clone - WARNING! PROJECT CREATION! ~ psaclone.psautomate.io
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
WARNING ~ WARNING ~ WARNING ~ WARNING ~ WARNING ~ WARNING ~ WARNING

Creating a NEW PROJECT will require a new Google CLIENT ID and SECRET from
this project to be created! As a result when finished; this will also
result in destroying the set gdrive/sdrive information due to the new
project being created!

This will also destroy any TRANSPORT MODE deployed and including any
mounts. Emby, Plex, and JellyFin Docker containers will also be REMOVED
to prevent any meta-data loss. When set, just redeploy them and will be
good to!

Do You Want to Proceed?
[1] No
[2] Yes

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
read -p '↘️  Input Choice | Press [Enter]: ' typed < /dev/tty
case $typed in
1 )
  clonestart ;;
2 )
  a=bc ;;
* )
  optionsmenu ;;
esac

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 PG Clone - Project Name ~ psaclone.psautomate.io
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Name of your project? Ensure the PROJECT NAME is one word; all lowercase;
no spaces!

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
read -p '↘️  Input Name | Press [Enter]: ' typed < /dev/tty
if [[ "$typed" == "" ]]; then projectnameset; else buildproject; fi
}

buildproject () {
echo ""
date=`date +%m%d`
rand=$(echo $((1 + RANDOM + RANDOM + RANDOM )))
projectid="pg-$typed-${date}${rand}"
gcloud projects create $projectid --account=${psacloneemail}

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 ID: $projectid ~ Created
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 PG Clone - Enabling the API (Standby)!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF

gcloud services enable drive.googleapis.com --project $projectid --account=${psacloneemail}
echo "$projectid" > /psa/rclone/psaclone.project

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 PG Clone - Resetting Prior Stored Information
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
rm -rf /psa/rclone/psaclone.secret 1>/dev/null 2>&1
rm -rf /psa/rclone/psaclone.public 1>/dev/null 2>&1
rm -rf /psa/rclone/psaclone.secret 1>/dev/null 2>&1
rm -rf /psa/rclone/.sd 1>/dev/null 2>&1
rm -rf /psa/rclone/.gd 1>/dev/null 2>&1
rm -rf /psa/rclone/.gc 1>/dev/null 2>&1
rm -rf /psa/rclone/.sc 1>/dev/null 2>&1
rm -rf /psa/rclone/psaclone.teamdrive 1>/dev/null 2>&1
rm -rf /psa/rclone/deployed.version 1>/dev/null 2>&1

docker stop jellyfin 1>/dev/null 2>&1
docker stop plex 1>/dev/null 2>&1
docker stop emby 1>/dev/null 2>&1
docker rm jellyfin 1>/dev/null 2>&1
docker rm plex 1>/dev/null 2>&1
docker rm emby 1>/dev/null 2>&1

ansible-playbook /psa/psaclone/ymls/remove.yml
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 PG Clone - Prior Stored Information is Reset!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

NOTE: If Plex, Emby, and/or JellyFin was deployed; redeploy them through
PG Box when complete! Ensuring that the containers do not self erase
meta-data due to the mounts being offline!

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

read -p '↘️  Acknowledge Info | Press [ENTER] ' typed < /dev/tty
clonestart
}
