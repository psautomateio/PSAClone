#!/bin/bash
#
# Title:      PSAutomate
# Based On:   PGBlitz (Reference Title File)
# Original Author(s):  Admin9705 - Deiteq
# PSAutomate Auther: fattylewis
# URL:        https://psautomate.io - http://github.psautomate.io
# GNU:        General Public License v3.0
################################################################################
keyinputpublic () {
psaclonevars
if [[ "$psacloneid" == "ACTIVE" ]]; then
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 PSA Clone - Change Values? ~ psaclone.psautomate.io
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
CLIENT ID
$psaclonepublic

SECRET ID
$psaclonesecret

WARNING: Changing the values will RESET & DELETE the following:
1. GDrive
2. SDrive
3. Service Keys

Change the Stored Values?
[1] No [2] Yes

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
read -p '↘️  Input Value | Press [Enter]: ' typed < /dev/tty
case $typed in
2 )
    rm -rf /psa/rclone/.gc 1>/dev/null 2>&1
    rm -rf /psa/rclone/.gd 1>/dev/null 2>&1
    rm -rf /psa/rclone/.sc 1>/dev/null 2>&1
    rm -rf /psa/rclone/.sd 1>/dev/null 2>&1
    rm -rf /psa/rclone/psaclone.teamdrive 1>/dev/null 2>&1
    rm -rf /psa/rclone/psaclone.public 1>/dev/null 2>&1
    rm -rf /psa/rclone/psaclone.secret 1>/dev/null 2>&1
    ;;
1 )
    clonestart ;;
* )
    keyinputpublic ;;
esac

fi

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 PSA Clone - Client ID ~ psaclone.psautomate.io
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Visit oauth.pgblitz.com in order to generate your Client ID! Ensure that
you input the CORRECT Client ID from your current project!

Quitting? Type > exit
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

read -p '↘️  Client ID | Press [Enter]: ' clientid < /dev/tty
if [ "$clientid" = "" ]; then keyinput; fi
if [ "$clientid" = "exit" ]; then clonestart; fi
keyinputsecret
}

keyinputsecret () {
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 PSA Clone - Secret ~ psaclone.psautomate.io
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Visit oauth.pgblitz.com in order to generate your Secret! Ensure that
you input the CORRECT Secret ID from your current project!

Quitting? Type > exit
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

read -p '↘️  Secret ID | Press [Enter]: ' secretid < /dev/tty
if [ "$secretid" = "" ]; then keyinputsecret; fi
if [ "$secretid" = "exit" ]; then clonestart; fi

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 PSA Clone - Output ~ psaclone.psautomate.io
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

CLIENT ID
$clientid

SECRET ID
$secretid

Is the following information correct?
[1] Yes
[2] No
[Z] Exit

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

read -p '↘️  Input Information | Press [Enter]: ' typed < /dev/tty

case $typed in
1 )
    echo "$clientid" > /psa/rclone/psaclone.public
    echo "$secretid" > /psa/rclone/psaclone.secret
    echo
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    read -p '↘️  Information Stored | Press [Enter] ' secretid < /dev/tty
    echo "SET" > /psa/rclone/psaclone.id
    ;;
2 )
    echo
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    read -p '↘️  Restarting Process | Press [Enter] ' secretid < /dev/tty
    keyinputpublic
    ;;
z )
    echo
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    read -p '↘️  Nothing Saved! Exiting! | Press [Enter] ' secretid < /dev/tty
    ;;
Z )
    echo
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    read -p '↘️  Nothing Saved! Exiting! | Press [Enter] ' secretid < /dev/tty
    ;;
* )
    clonestart ;;
esac
clonestart
}

publicsecretchecker () {
psaclonevars
if [[ "$psacloneid" == "NOT-SET" ]]; then

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎 Fail Notice ~ oauth.psautomate.io
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

💬  Public & Secret Key - NOT SET!

NOTE: Nothing can occur unless the public & secret key are set! Without
setting them; PGBlitz cannot create keys, nor create rclone configurations
to mount the required drives!

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
read -p '↘️  Acknowledge Info | Press [ENTER] ' typed < /dev/tty
clonestart
fi
}
