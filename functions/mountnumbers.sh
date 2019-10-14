#!/bin/bash
#
# Title:      PSAutomate
# Based On:   PGBlitz (Reference Title File)
# Original Author(s):  Admin9705 - Deiteq
# PSAutomate Auther: fattylewis
# URL:        https://psautomate.io - http://github.psautomate.io
# GNU:        General Public License v3.0
################################################################################
mountnumbers () {
    psaclonevars

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
RClone Mount Settings ~ clonevalues.psautomate.io
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

NOTE 1: Read the wiki on how changing the settings impact stability and
performance! After changing the settings, you must redeploy the mounts!

NOTE 2: You will be editing a JSON file! Only change what's within the
quotations! If you mess things up, your mounts can deploy incorrectly!

NOTE 3: To RESET the JSON change the "resetdefaults" setting to "yes"
via all lowercase.

NOTE 4: Final Note, to SAVE > Press CTRL + X, Select "YES", and PRESS
[ENTER] to save the settings! Do not change the name of the file!

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

    read -rp '↘️  PRESS [ENTER] to CONTINUE! ' fluffycat < /dev/tty

nano /psa/rclone/psaclone.json

}
