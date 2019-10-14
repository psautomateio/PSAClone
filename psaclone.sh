#!/bin/bash
#
# Title:      PSAutomate
# Based On:   PGBlitz (Reference Title File)
# Original Author(s):  Admin9705 - Deiteq
# PSAutomate Auther: fattylewis
# URL:        https://psautomate.io - http://github.psautomate.io
# GNU:        General Public License v3.0
################################################################################
source /psa/psaclone/functions/functions.sh
source /psa/psaclone/functions/variables.sh
source /psa/psaclone/functions/mountnumbers.sh
source /psa/psaclone/functions/keys.sh
source /psa/psaclone/functions/keyback.sh
source /psa/psaclone/functions/psaclone.sh
source /psa/psaclone/functions/gaccount.sh
source /psa/psaclone/functions/publicsecret.sh
source /psa/psaclone/functions/variables.sh
source /psa/psaclone/functions/transportselect.sh
source /psa/psaclone/functions/projectname.sh
source /psa/psaclone/functions/clonestartoutput.sh
source /psa/psaclone/functions/oauth.sh
source /psa/psaclone/functions/passwords.sh
source /psa/psaclone/functions/oauthcheck.sh
source /psa/psaclone/functions/keysbuild.sh
source /psa/psaclone/functions/emails.sh
source /psa/psaclone/functions/deploy.sh
source /psa/psaclone/functions/rcloneinstall.sh
source /psa/psaclone/functions/deploytransfer.sh
source /psa/psaclone/functions/deploysdrive.sh
source /psa/psaclone/functions/multihd.sh
source /psa/psaclone/functions/deploylocal.sh
source /psa/psaclone/functions/createsdrive.sh
source /psa/psaclone/functions/cloneclean.sh
source /psa/psaclone/functions/uagent.sh
################################################################################
rcloneinstall

# (functions.sh) Ensures variables and folders exist
psaclonevars

# (functions.sh) User cannot proceed until they set transport and data type
mustset

# (functions.sh) Ensures that fuse is set correct for rclone
rcpiece

clonestart
