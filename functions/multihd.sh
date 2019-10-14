#!/bin/bash
#
# Title:      PSAutomate
# Based On:   PGBlitz (Reference Title File)
# Original Author(s):  Admin9705 - Deiteq
# PSAutomate Auther: fattylewis
# URL:        https://psautomate.io - http://github.psautomate.io
# GNU:        General Public License v3.0
################################################################################
multihdreadonly () {

  # calls up standard variables
  psaclonevars

  # removes the temporary variable when starting
  rm -rf /psa/var/.tmp.multihd 1>/dev/null 2>&1

    # reads the list of paths
    while read p; do

       # prevents copying blanks areas
       if [[ "$p" != "" ]]; then
         echo -n "$p=NC:" >> /psa/var/.tmp.multihd
         chown -R 1000:1000 "$p"
         chmod -R 755 "$p"
       fi

    done </psa/var/multihd.paths

}
