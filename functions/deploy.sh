#!/bin/bash
#
# Title:      PSAutomate
# Based On:   PGBlitz (Reference Title File)
# Original Author(s):  Admin9705 - Deiteq
# PSAutomate Auther: fattylewis
# URL:        https://psautomate.io - http://github.psautomate.io
# GNU:        General Public License v3.0
################################################################################
deploysdrive () {
  deployblitzstartcheck # At Bottom - Ensure Keys Are Made

# RCLONE BUILD
echo "#------------------------------------------" > /psa/rclone/psablitz.conf
echo "#RClone Rewrite | Visit https://psautomate.io" >> /psa/rclone/psablitz.conf
echo "#------------------------------------------" >> /psa/rclone/psablitz.conf

cat /psa/rclone/.gd >> /psa/rclone/psablitz.conf

if [[ $(cat "/psa/rclone/.gc") != "NOT-SET" ]]; then
echo ""
cat /psa/rclone/.gc >> /psa/rclone/psablitz.conf; fi

cat /psa/rclone/.sd >> /psa/rclone/psablitz.conf

if [[ $(cat "/psa/rclone/.sc") != "NOT-SET" ]]; then
echo ""
cat /psa/rclone/.sc >> /psa/rclone/psablitz.conf; fi

cat /psa/var/.keys >> /psa/rclone/psablitz.conf

deploydrives
}

deploygdrive () {
# RCLONE BUILD
echo "#------------------------------------------" > /psa/rclone/psablitz.conf
echo "#RClone Rewrite | Visit https://psautomate.io" >> /psa/rclone/psablitz.conf
echo "#------------------------------------------" >> /psa/rclone/psablitz.conf

cat /psa/rclone/.gd > /psa/rclone/psablitz.conf

if [[ $(cat "/psa/rclone/.gc") != "NOT-SET" ]]; then
echo ""
cat /psa/rclone/.gc >> /psa/rclone/psablitz.conf; fi
deploydrives
}

deploydrives () {
  fail=0
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Conducting RClone Mount Checks ~ psaclone.psautomate.io
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF

if [ -e "/psa/logs/.drivelog" ]; then rm -rf /psa/logs/.drivelog; fi
touch /psa/logs/.drivelog

  if [[ "$transport" = "gd" ]]; then
    gdrivemod
    multihdreadonly
  elif [[ "$transport" == "gc" ]]; then
    gdrivemod
    gcryptmod
    multihdreadonly
  elif [[ "$transport" == "sd" ]]; then
    gdrivemod
    sdrivemod
    gdsamod
    multihdreadonly
  elif [[ "$transport" == "sc" ]]; then
    gdrivemod
    sdrivemod
    gdsamod
    gcryptmod
    scryptmod
    gdsacryptmod
    multihdreadonly
  fi

cat /psa/logs/.drivelog
logcheck=$(cat /psa/logs/.drivelog | grep "Failed")

if [[ "$logcheck" == "" ]]; then
  if [[ "$transport" == "gd" || "$transport" == "gc" || "$transport" == "sd" || "$transport" == "sc" ]]; then executetransport; fi
else
  if [[ "$transport" == "sd" || "$transport" == "sc" ]]; then
  emessage="
  NOTE1: User forgot to share out GDSA E-Mail to Team Drive
  NOTE2: Conducted a blitz key restore and keys are no longer valid
  "; fi

tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 RClone Mount Checks - Failed
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

CANNOT DEPLOY!

POSSIBLE REASONS:
1. GSuite Account is no longer valid or suspended
2. Client ID and/or Secret are invalid and/or no longer exist
$emessage
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
read -p '↘️  Acknowledge Info | Press [ENTER] ' typed2 < /dev/tty
clonestart
fi
}

########################################################################################
gdrivemod ()
{
  initial=$(rclone lsd --config /psa/rclone/psablitz.conf gd: | grep -oP psautomate | head -n1)

  if [[ "$initial" != "psautomate" ]]; then
    rclone mkdir --config /psa/rclone/psablitz.conf gd:/psautomate
    initial=$(rclone lsd --config /psa/rclone/psablitz.conf gd: | grep -oP psautomate | head -n1)
  fi

  if [[ "$initial" == "psautomate" ]]; then echo "GDRIVE :  Passed" >> /psa/logs/.drivelog; else echo "GDRIVE :  Failed" >> /psa/logs/.drivelog; fi
}
sdrivemod ()
{
  initial=$(rclone lsd --config /psa/rclone/psablitz.conf sd: | grep -oP psautomate | head -n1)

  if [[ "tinitial" != "psautomate" ]]; then
    rclone mkdir --config /psa/rclone/psablitz.conf gd:/psautomate
    initial=$(rclone lsd --config /psa/rclone/psablitz.conf sd: | grep -oP psautomate | head -n1)
  fi

  if [[ "$initial" == "psautomate" ]]; then echo "SDRIVE :  Passed" >> /psa/logs/.drivelog; else echo "SDRIVE :  Failed" >> /psa/logs/.drivelog; fi
}
gcryptmod ()
{
  c1initial=$(rclone lsd --config /psa/rclone/psablitz.conf gd: | grep -oP encrypt | head -n1)
  c2initial=$(rclone lsd --config /psa/rclone/psablitz.conf gc: | grep -oP psautomate | head -n1)

  if [[ "$c1initial" != "encrypt" ]]; then
    rclone mkdir --config /psa/rclone/psablitz.conf gd:/encrypt
    c1initial=$(rclone lsd --config /psa/rclone/psablitz.conf gd: | grep -oP encrypt | head -n1)
  fi
  if [[ "$c2initial" != "psautomate" ]]; then
    rclone mkdir --config /psa/rclone/psablitz.conf gc:/psautomate
    c2initial=$(rclone lsd --config /psa/rclone/psablitz.conf gc: | grep -oP psautomate | head -n1)
  fi

  if [[ "$c1initial" == "encrypt" ]]; then echo "GCRYPT1:  Passed" >> /psa/logs/.drivelog; else echo "GCRYPT1:  Failed" >> /psa/logs/.drivelog; fi
  if [[ "$c2initial" == "psautomate" ]]; then echo "GCRYPT2:  Passed" >> /psa/logs/.drivelog; else echo "GCRYPT2:  Failed" >> /psa/logs/.drivelog; fi
}
scryptmod ()
{
  c1initial=$(rclone lsd --config /psa/rclone/psablitz.conf sd: | grep -oP encrypt | head -n1)
  c2initial=$(rclone lsd --config /psa/rclone/psablitz.conf sc: | grep -oP psautomate | head -n1)

  if [[ "$c1initial" != "encrypt" ]]; then
    rclone mkdir --config /psa/rclone/psablitz.conf sd:/encrypt
    c1initial=$(rclone lsd --config /psa/rclone/psablitz.conf sd: | grep -oP encrypt | head -n1)
  fi
  if [[ "$c2initial" != "psautomate" ]]; then
    rclone mkdir --config /psa/rclone/psablitz.conf sc:/psautomate
    c2initial=$(rclone lsd --config /psa/rclone/psablitz.conf sc: | grep -oP psautomate | head -n1)
  fi

  if [[ "$c1initial" == "encrypt" ]]; then echo "SCRYPT1:  Passed" >> /psa/logs/.drivelog; else echo "SCRYPT1:  Failed" >> /psa/logs/.drivelog; fi
  if [[ "$c2initial" == "psautomate" ]]; then echo "SCRYPT2:  Passed" >> /psa/logs/.drivelog; else echo "SCRYPT2:  Failed" >> /psa/logs/.drivelog; fi
}
gdsamod ()
{
  initial=$(rclone lsd --config /psa/rclone/psablitz.conf GDSA01: | grep -oP psautomate | head -n1)

  if [[ "$initial" != "psautomate" ]]; then
    rclone mkdir --config /psa/rclone/psablitz.conf GDSA01:/psautomate
    initial=$(rclone lsd --config /psa/rclone/psablitz.conf GDSA01: | grep -oP psautomate | head -n1)
  fi

  if [[ "$initial" == "psautomate" ]]; then echo "GDSA01 :  Passed" >> /psa/logs/.drivelog; else echo "GDSA01 :  Failed" >> /psa/logs/.drivelog; fi
}
gdsacryptmod ()
{
  initial=$(rclone lsd --config /psa/rclone/psablitz.conf GDSA01C: | grep -oP encrypt | head -n1)

  if [[ "$initial" != "psautomate" ]]; then
    rclone mkdir --config /psa/rclone/psablitz.conf GDSA01C:/psautomate
    initial=$(rclone lsd --config /psa/rclone/psablitz.conf GDSA01C: | grep -oP psautomate | head -n1)
  fi

  if [[ "$initial" == "psautomate" ]]; then echo "GDSA01C:  Passed" >> /psa/logs/.drivelog; else echo "GDSA01C:  Failed" >> /psa/logs/.drivelog; fi
}
################################################################################
deployblitzstartcheck () {

psaclonevars
if [[ "$displaykey" == "0" ]]; then
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎 Fail Notice ~ psaclone.psautomate.io
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

💬  There are [0] keys generated for PSA Blitz! Create those first!

NOTE: Without any keys, PSA Blitz cannot upload any data without the use
of service accounts

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

read -p '↘️  Acknowledge Info | Press [ENTER] ' typed < /dev/tty
clonestart
fi
}
