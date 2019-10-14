#!/bin/bash
#
# Title:      PSAutomate
# Based On:   PGBlitz (Reference Title File)
# Original Author(s):  Admin9705 - Deiteq
# PSAutomate Auther: fattylewis
# URL:        https://psautomate.io - http://github.psautomate.io
# GNU:        General Public License v3.0
################################################################################
clonestartoutput () {
psaclonevars

echo "ACTIVELY DEPLOYED: [$dversionoutput]"
echo ""

if [[ "$demo" == "ON " ]]; then mainid="********"; else mainid="$psacloneemail"; fi

if [[ "$transport" == "gd" ]]; then
tee <<-EOF
[1] Client ID & Secret    [${psacloneid}]
[2] GDrive                [$gdstatus]
EOF
elif [[ "$transport" == "gc" ]]; then
tee <<-EOF
[1] Client ID & Secret    [${psacloneid}]
[2] Passwords             [$pstatus]
[3] GDrive                [$gdstatus] - [$gcstatus]
EOF
elif [[ "$transport" == "sd" ]]; then
tee <<-EOF
[1] Google Account Login  [$mainid]
[2] Project Name          [$psacloneproject]
[3] Client ID & Secret    [${psacloneid}]
[4] SDrive Label          [$sdname]
[5] SDrive OAuth          [$sdstatus]
[6] GDrive OAuth          [$gdstatus]
[7] Key Management        [$displaykey] Built
[8] SDrive (E-Mail Share Generator)
EOF
elif [[ "$transport" == "sc" ]]; then
tee <<-EOF
[1] Google Account Login  [$mainid]
[2] Project Name          [$psacloneproject]
[3] Client ID & Secret    [${psacloneid}]
[4] Passwords             [$pstatus]
[5] SDrive Label          [$sdname]
[6] SDrive | SDrive       [$sdstatus] - [$scstatus]
[7] GDrive | GCrypt       [$gdstatus] - [$gcstatus]
[8] Key Management        [$displaykey] Built
[9] SDrive (E-Mail Share Generator)
EOF
elif [[ "$transport" == "le" ]]; then
tee <<-EOF
NOTE: The default drive is already factored in! Only additional locations
or hard drives are required to be added!
EOF
fi
}

errorteamdrive ()

{
if [[ "$sdname" == "NOT-SET" ]]; then
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 Setup the SDrive Label First! ~ http://psaclone.psautomate.io
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

NOTE: Set up your SDrive Label prior to executing the SDrive OAuth.
Basically, we cannot authorize a ShareDrive without knowing which
ShareDrive is being utilized first!

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
read -rp '↘️  Acknowledge Info | Press [ENTER] ' typed < /dev/tty
clonestart
fi
}

clonestart () {
psaclonevars

# pull throttle speeds based on role
if [[ "$transport" == "gd" || "$transport" == "gc" ]]; then
throttle=$(cat /psa/var/move.bw)
output1="[C] Transport Select"
else
throttle=$(cat /psa/var/blitz.bw)
output1="[C] Options"
fi

if [[ "$transport" != "gd" && "$transport" != "gc" && "$transport" != "sd" && "$transport" != "sc" && "$transport" != "le" ]]; then
rm -rf /psa/rclone/psaclone.transport 1>/dev/null 2>&1
mustset; fi

    if [[ "$transport" == "gd" ]]; then outputversion="GDrive Unencrypted"
  elif [[ "$transport" == "gc" ]]; then outputversion="GDrive Encrypted"
  elif [[ "$transport" == "sd" ]]; then outputversion="SDrive Unencrypted"
  elif [[ "$transport" == "sc" ]]; then outputversion="SDrive Encrypted"
  elif [[ "$transport" == "le" ]]; then outputversion="Local Hard Drives"
  fi

if [[ "$transport" == "le" ]]; then
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
💪 Welcome to PSA Clone ~ http://psaclone.psautomate.io
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
clonestartoutput

tee <<-EOF

[1] Deploy     (Local HD/Mounts)
[2] MultiHD    (Add Mounts xor Hard Drives)
[3] Transport  (Change Transportion Mode)
[Z] Exit

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
read -rp '↘️  Input Selection | Press [ENTER]: ' typed < /dev/tty

localstartoutput

else
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
💪 Welcome to PSA Clone ~ http://psaclone.psautomate.io
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
clonestartoutput

tee <<-EOF

[A] Deploy $outputversion
[B] Throttle              [${throttle} MB]
[C] Options
[Z] Exit

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
read -rp '↘️  Input Selection | Press [ENTER]: ' typed < /dev/tty
clonestartactions
fi
}

localstartoutput () {
  case $typed in
  1 )
      executelocal ;;
  2 )
      bash /psa/psablitz/menu/psacloner/multihd.sh ;;
  3 )
      transportselect ;;
  z )
      exit ;;
  Z )
      exit ;;
  * )
      clonestart ;;
  esac
clonestart
}

clonestartactions () {
if [[ "$transport" == "gd" ]]; then
  case $typed in
      1 )
          keyinputpublic ;;
      2 )
          publicsecretchecker
          echo "gd" > /psa/rclone/deploy.version
          oauth ;;
      z )
          exit ;;
      Z )
          exit ;;
      a )
          publicsecretchecker
          mountchecker
          deploygdrive
          ;; ## fill
      A )
          publicsecretchecker
          mountchecker
          deploygdrive
          ;; ## flll
      b )
          setthrottlemove ;;
      B )
          setthrottlemove ;;
      c )
          optionsmengu ;;
      C )
          optionsmengu ;;
      * )
          clonestart ;;
    esac
elif [[ "$transport" == "gc" ]]; then
  case $typed in
      1 )
          keyinputpublic ;;
      2 )
          publicsecretchecker
          blitzpasswordmain ;;
      3 )
          publicsecretchecker
          passwordcheck
          echo "gd" > /psa/rclone/deploy.version
          oauth ;;
      z )
          exit ;;
      Z )
          exit ;;
      a )
          publicsecretchecker
          passwordcheck
          mountchecker
          deploygdrive
          ;; ## fill
      A )
          publicsecretchecker
          passwordcheck
          mountchecker
          deploygdrive
          ;; ## flll
      b )
          setthrottlemove ;;
      B )
          setthrottlemove ;;
      c )
          optionsmengu ;;
      C )
          optionsmengu ;;
      * )
          clonestart ;;
    esac
elif [[ "$transport" == "sd" ]]; then
  case $typed in
        1 )
            glogin ;;
        2 )
            exisitingproject ;;
        3 )
            keyinputpublic ;;
        4 )
            publicsecretchecker
            tlabeloauth ;;
        5 )
            publicsecretchecker
            tlabelchecker
            echo "sd" > /psa/rclone/deploy.version
            oauth ;;
        6 )
            publicsecretchecker
            echo "gd" > /psa/rclone/deploy.version
            oauth ;;
        7 )
            publicsecretchecker
            tlabelchecker
            mountchecker
            projectnamecheck
            keystart
            gdsaemail ;;
        8 )
            publicsecretchecker
            tlabelchecker
            mountchecker
            projectnamecheck
            deployblitzstartcheck
            emailgen ;;
        z )
            exit ;;
        Z )
            exit ;;
        a )
            publicsecretchecker
            tlabelchecker
            mountchecker
            deploysdrive
            ;; ## fill
        A )
            publicsecretchecker
            tlabelchecker
            mountchecker
            deploysdrive
            ;; ## flll
        b )
            setthrottleblitz ;;
        B )
            setthrottleblitz ;;
        c )
            optionsmenu ;;
        C )
            optionsmenu ;;
        d )
            mountnumbers ;;
        D )
            mountnumbers ;;
        * )
            clonestart ;;
      esac
elif [[ "$transport" == "sc" ]]; then
  case $typed in
        1 )
            glogin ;;
        2 )
            exisitingproject ;;
        3 )
            keyinputpublic ;;
        4 )
            publicsecretchecker
            blitzpasswordmain ;;
        5 )
            publicsecretchecker
            tlabeloauth ;;
        6 )
            publicsecretchecker
            passwordcheck
            tlabelchecker
            echo "sc" > /psa/rclone/deploy.version
            oauth ;;
        7 )
            publicsecretchecker
            passwordcheck
            echo "sc" > /psa/rclone/deploy.version
            oauth ;;

        8 )
            publicsecretchecker
            passwordcheck
            tlabelchecker
            mountchecker
            projectnamecheck
            keystart
            gdsaemail ;;
        9 )
            publicsecretchecker
            passwordcheck
            tlabelchecker
            mountchecker
            projectnamecheck
            deployblitzstartcheck
            emailgen ;;
        z )
            exit ;;
        Z )
            exit ;;
        a )
            publicsecretchecker
            passwordcheck
            tlabelchecker
            mountchecker
            deploysdrive
            ;; ## fill
        A )
            publicsecretchecker
            passwordcheck
            tlabelchecker
            mountchecker
            deploysdrive
            ;; ## flll
        b )
            setthrottleblitz ;;
        B )
            setthrottleblitz ;;
        c )
            optionsmenu ;;
        C )
            optionsmenu ;;
        d )
            mountnumbers ;;
        D )
            mountnumbers ;;
        * )
            clonestart ;;
      esac
fi
clonestart
}

# For Blitz
optionsmenu () {
psaclonevars
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
💪 Options Interface ~ http://psaclone.psautomate.io
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[1] Transport Select         | Change Transport Type
[2] RClone Mount Settings    | Change Varibles to for the Mount
[3] Multi-HD Option          | Add Multi-Points and Options
[4] Destroy All Service Keys | Wipes All Keys for the Project
[5] Create New Project       | Wipes Resets Everything
[6] Demo Mode                | Hide Displaying the E-Mail Address - ${demo}
[7] Clone Clean              | Destory Garbage Files - After [$cloneclean]M
[8] Change User Agent        | Currently: ${uagent}
[9] Create a Share Drive
[Z] Exit

NOTE: Creating NEW PROJECT [9]? User must create a CLIENT ID & SECRET for
that project! We will assist in creating the project and enabling the API!

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
read -rp '↘️  Input Selection | Press [ENTER]: ' typed < /dev/tty

case $typed in
      1 )
          transportselect
          clonestart ;;
      2 )
          mountnumbers ;;
      3 )
          bash /psa/psablitz/menu/psacloner/multihd.sh ;;
      4 )
          deletekeys ;;
      5 )
          projectnameset ;;
      6 )
          demomode ;;
      7 )
          cloneclean ;;
      8 )
          uagent ;;
      9 )
          csdrive ;;
      Z )
          clonestart ;;
      z )
          clonestart ;;
      * )
          optionsmenu ;;
esac
optionsmenu
}

# For Move
optionsmengu () {
psaclonevars
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
💪 Options Interface ~ http://psaclone.psautomate.io
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[1] Transport Select         | Change Transport Type
[2] RClone Mount Settings    | Change Varibles to for the Mount
[3] Multi-HD Option          | Add Multi-Points and Options
[4] Clone Clean              | Destory Garbage Files - After [$cloneclean]M
[5] Change User Agent - ${uagent}
[Z] Exit

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
read -rp '↘️  Input Selection | Press [ENTER]: ' typed < /dev/tty

case $typed in
      1 )
          transportselect
          clonestart ;;
      2 )
          mountnumbers ;;
      3 )
          bash /psa/psablitz/menu/psacloner/multihd.sh ;;
      4 )
          cloneclean ;;
      5 )
          uagent ;;
      Z )
          clonestart ;;
      z )
          clonestart ;;
      * )
          optionsmenu ;;
esac
optionsmenu
}

demomode () {
  if [[ "$demo" = "OFF" ]]; then echo "ON " > /psa/rclone/psaclone.demo
  else echo "OFF" > /psa/rclone/psaclone.demo; fi

psaclonevars
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 DEMO MODE IS NOW: $demo | PRESS [ENTER] to CONFIRM!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
read -rp '' typed < /dev/tty
optionsmenu

}
