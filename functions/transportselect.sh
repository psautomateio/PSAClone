#!/bin/bash
#
# Title:      PSAutomate
# Based On:   PGBlitz (Reference Title File)
# Original Author(s):  Admin9705 - Deiteq
# PSAutomate Auther: fattylewis
# URL:        https://psautomate.io - http://github.psautomate.io
# GNU:        General Public License v3.0
################################################################################
transportselect () {
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
💪 Set psaclone Method ~ http://psaclone.psautomate.io
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
NOTE: Please visit the link and understand what your doing first!

[1] Blitz GDrive - Unencrypt | Easy    | 750GB Daily Transfer Max
[2] Blitz GDrive - Encrypted | Novice  | 750GB Daily Transfer Max
[3] Blitz SDrive - Unencrypt | Complex | Exceed 750GB Daily Max Cap
[4] Blitz SDrive - Encrypted | Complex | Exceed 750GB Daily Max Cap
[5] Blitz Local  - Local HDs | Easy    | Utilizes Server HD's Only

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

read -rp '↘️  Input Selection | Press [ENTER]: ' typed < /dev/tty

case $typed in
    1 )
    echo "gd" > /psa/rclone/psaclone.transport ;;
    2 )
    echo "gc" > /psa/rclone/psaclone.transport ;;
    3 )
    echo "sd" > /psa/rclone/psaclone.transport ;;
    4 )
    echo "sc" > /psa/rclone/psaclone.transport ;;
    5 )
    echo "le" > /psa/rclone/psaclone.transport ;;
    * )
        transportselect ;;
esac
}
