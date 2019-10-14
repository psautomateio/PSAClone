#!/bin/bash
#
# Title:      PSAutomate
# Based On:   PGBlitz (Reference Title File)
# Original Author(s):  Admin9705 - Deiteq
# PSAutomate Auther: fattylewis
# URL:        https://psautomate.io - http://github.psautomate.io
# GNU:        General Public License v3.0
################################################################################
keystart () {
psaclonevars

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Key Builder ~ http://psaclone.psautomate.io
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
QUESTION - Create how many keys for PSABlitz? (From 2 thru 20 )

MATH:
2  Keys = 1.5 TB Daily | 6  Keys = 4.5 TB Daily
10 Keys = 7.5 TB Daily | 20 Keys = 15  TB Daily

NOTE 1: Creating more keys DOES NOT SPEED up your transfers
NOTE 2: Realistic key generation for most are 6 keys
NOTE 3: Generating 100 keys over time, you must delete them all to create
        more, which is why making tons of keys is not ideal!

Quitting? Type >>> exit
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
  read -p '↘️  Type a Number [ 2 thru 20 ] | Press [ENTER]: ' typed < /dev/tty

exitclone

num=$typed
if [[ "$typed" -le "0" || "$typed" -ge "51" ]]; then keystart
elif [[ "$typed" -ge "1" && "$typed" -le "50" ]]; then keyphase2
else keystart; fi
}

keyphase2 () {
num=$typed

rm -rf /psa/var/blitzkeys 1>/dev/null 2>&1
mkdir -p /psa/var/blitzkeys

cat /psa/rclone/.gd > /psa/rclone/psablitz.conf
if [ -e "/psa/rclone/.sd" ]; then cat /psa/rclone/.sd >> /psa/var/.keytemp; fi
if [ -e "/psa/rclone/.gc" ]; then cat /psa/rclone/.gc >> /psa/var/.keytemp; fi
if [ -e "/psa/rclone/.sc" ]; then cat /psa/rclone/.sc >> /psa/var/.keytemp; fi

gcloud --account=${psacloneemail} iam service-accounts list |  awk '{print $1}' | \
       tail -n +2 | cut -c2- | cut -f1 -d "?" | sort | uniq > /psa/var/.gcloudblitz

 rm -rf /psa/var/.blitzbuild 1>/dev/null 2>&1
 touch /psa/var/.blitzbuild
 while read p; do
   echo $p > /psa/var/.blitztemp
   blitzcheck=$(grep "blitz" /psa/var/.blitztemp)
   if [[ "$blitzcheck" != "" ]]; then echo $p >> /psa/var/.blitzbuild; fi
 done </psa/var/.gcloudblitz

keystotal=$(cat /psa/var/.blitzbuild | wc -l)
# do a 100 calculation - reminder

keysleft=$num
count=0
gdsacount=0
gcount=0
tempbuild=0
rm -rf /psa/var/.keys 1>/dev/null 2>&1
touch /psa/var/.keys
rm -rf /psa/var/.blitzkeys
mkdir -p /psa/var/.blitzkeys
echo "" > /psa/var/.keys

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Key Generator ~ [$num] keys
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

gdsacount () {
  ((gcount++))
  if [[ "$gcount" -ge "1" && "$gcount" -le "9" ]]; then tempbuild=0${gcount}
else tempbuild=$gcount; fi
}

keycreate1 () {
    #echo $count # for tshoot
    gdsacount
    gcloud --account=${psacloneemail} iam service-accounts create blitz0${count} --display-name “blitz0${count}”
    gcloud --account=${psacloneemail} iam service-accounts keys create /psa/var/.blitzkeys/GDSA${tempbuild} --iam-account blitz0${count}@${psacloneproject}.iam.gserviceaccount.com --key-file-type="json"
    gdsabuild
    if [[ "$gcount" -ge "1" && "$gcount" -le "9" ]]; then echo "blitz0${count} is linked to GDSA${tempbuild}"
    else echo "blitz0${count} is linked to GDSA${gcount}"; fi
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    keysleft=$((keysleft-1))
    flip=on
}

keycreate2 () {
    #echo $count # for tshoot
    gdsacount
    gcloud --account=${psacloneemail} iam service-accounts create blitz${count} --display-name “blitz${count}”
    gcloud --account=${psacloneemail} iam service-accounts keys create /psa/var/.blitzkeys/GDSA${tempbuild} --iam-account blitz${count}@${psacloneproject}.iam.gserviceaccount.com --key-file-type="json"
    gdsabuild
    if [[ "$gcount" -ge "1" && "$gcount" -le "9" ]]; then echo "blitz${count} is linked to GDSA${tempbuild}"
    else echo "blitz${count} is linked to GDSA${gcount}"; fi
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    keysleft=$((keysleft-1))
    flip=on
}

keysmade=0
while [[ "$keysleft" -gt "0" ]]; do
  flip=off
  while [[ "$flip" == "off" ]]; do
    ((count++))
    if [[ "$count" -ge "1" && "$count" -le "9" ]]; then
      if [[ $(grep "0${count}" /psa/var/.blitzbuild) = "" ]]; then keycreate1; fi
    else
      if [[ $(grep "${count}" /psa/var/.blitzbuild) = "" ]]; then keycreate2; fi; fi
  done
done

}

gdsabuild () {
psaclonevars
####tempbuild is need in order to call the correct gdsa
tee >> /psa/var/.keys <<-EOF
[GDSA${tempbuild}]
type = drive
scope = drive
service_account_file = /psa/var/.blitzkeys/GDSA${tempbuild}
team_drive = ${sdid}

EOF

if [[ "$transport" == "sc" || "$transport" == "sd" ]]; then
encpassword=$(rclone obscure "${clonepassword}")
encsalt=$(rclone obscure "${clonesalt}")

tee >> /psa/var/.keys <<-EOF
[GDSA${tempbuild}C]
type = crypt
remote = GDSA${tempbuild}:/encrypt
filename_encryption = standard
directory_name_encryption = true
password = $encpassword
password2 = $encsalt

EOF

fi
#echo "" /psa/var/.keys
}

gdsaemail () {
tee <<-EOF
EOF

read -rp '↘️  Process Complete! Ready to Share E-Mails? | Press [ENTER] ' typed < /dev/tty
emailgen
}

deletekeys () {
psaclonevars
gcloud --account=${psacloneemail} iam service-accounts list > /psa/var/.deletelistpart1

  if [[ $(cat /psa/var/.deletelistpart1) == "" ]]; then

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Error! Nothing To Delete!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

NOTE: No Accounts for Project ~ $psacloneproject
are detected! Exiting!

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
read -p '↘️  Acknowledge Info! | PRESS [ENTER] ' token < /dev/tty
clonestart; fi

  rm -rf /psa/var/.listpart2 1>/dev/null 2>&1
  while read p; do
  echo $p > /psa/var/.listpart1
  writelist=$(grep pg-bumpnono-143619 /psa/var/.listpart1)
  if [[ "$writelist" != "" ]]; then echo $writelist >> /psa/var/.listpart2; fi
done </psa/var/.deletelistpart1

cat /psa/var/.listpart2 |  awk '{print $2}' | \
    sort | uniq > /psa/var/.gcloudblitz

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Keys to Delete?
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF
cat /psa/var/.gcloudblitz
tee <<-EOF

Delete All Keys for Project ~ ${psacloneproject}?

WARNING: If Plex, Emby, and/or JellyFin are using these keys, stop the
containers! Deleting keys in use by this project will result in those
containers losing metadata (due to being unable to access teamdrives)!

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

read -p '↘️  Type y or n | PRESS [ENTER]: ' typed < /dev/tty
case $typed in
    y )
        yesdeletekeys ;;
    Y )
        yesdeletekeys ;;
    N )
        clonestart ;;
    n )
        clonestart ;;
    * )
        deletekeys ;;
esac
}

yesdeletekeys () {
rm -rf /psa/var/.blitzkeys/* 1>/dev/null 2>&1
echo ""
while read p; do
gcloud --account=${psacloneemail} iam service-accounts delete $p --quiet
done </psa/var/.gcloudblitz

echo
read -p '↘️  Process Complete! | PRESS [ENTER]: ' token < /dev/tty
clonestart
}
