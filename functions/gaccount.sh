#!/bin/bash
#
# Title:      PSAutomate
# Based On:   PGBlitz (Reference Title File)
# Original Author(s):  Admin9705 - Deiteq
# PSAutomate Auther: fattylewis
# URL:        https://psautomate.io - http://github.psautomate.io
# GNU:        General Public License v3.0
################################################################################

# BAD INPUT
badinput () {
echo
read -p '⛔️ ERROR - Bad Input! | Press [ENTER] ' typed < /dev/tty
}

glogin () {

emailaccount=$(cat /psa/var/project.email)

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
💪 Set E-Mail Address ~ http://psaclone.psautomate.io
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
What email address from the Google Console do you want to be associated
with from your Google GSuite? Ensure that it exists!

Quitting? Type >>> exit
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

read -p '↘️  Input E-Mail | Press [ENTER]: ' typed < /dev/tty

if [[ "$typed" == "" ]]; then glogin; fi
if [[ "$typed" == "Exit" || "$typed" == "exit" || "$typed" == "EXIT" ]]; then clonestart; fi

gcloud auth login --account = $typed
gcloud info | grep Account: | cut -c 10- > /psa/var/project.account
account=$(cat /psa/var/project.account)

testcheck=$(gcloud auth list | grep "$typed")
if [[ "$testcheck" == "" ]]; then
echo
echo "INFO CHECK: E-Mail Address Failed!"
read -p '↘️  Acknowledge Info | Press [ENTER] ' typed < /dev/tty
glogin
fi

echo "$typed" > /psa/rclone/psaclone.email
}
