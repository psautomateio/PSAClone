#!/bin/bash
#
# Title:      PSAutomate
# Based On:   PGBlitz (Reference Title File)
# Original Author(s):  Admin9705 - Deiteq
# PSAutomate Auther: fattylewis
# URL:        https://psautomate.io - http://github.psautomate.io
# GNU:        General Public License v3.0
################################################################################
cloneclean () {
psaclonevars

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Clone Clean
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Clone Clean deletes garbage files in your downloads folder per every
[$cloneclean] minutes!

TORRENT USERS: Recommend that you set this number higher! If seeding,
Clone Clean will destory the seed files. Please set this number to a high
number of minutes. (IE - 1440 minutes = 1 day | 14440 minutes = 10 days)

WARNING: Do not set this too low because legitmate files!

Quitting? Type >>> exit
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
  read -p '↘️  Type Minutes (Minimum is 120) | PRESS [ENTER]: ' varinput < /dev/tty
  if [[ "$varinput" == "exit" || "$varinput" == "Exit" || "$varinput" == "EXIT" ]]; then clonestart; fi

  if [[ "$varinput" -lt "120" ]]; then cloneclean; fi

  echo "$varinput" > /psa/var/cloneclean
}
