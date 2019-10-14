### Falls under PSA Prune for Execution to Save Time & Sanity

# Outside Variables
dlpath=$(cat /psa/var/server.hd.path)
cleaner="$(cat /psa/var/cloneclean)"

# Starting Actions
touch /psa/logs/psablitz.log
mkdir -p "$dlpath/move"

# Repull excluded folder 
 wget -qN https://blahblah/PGBlitz/psaclone/v8.6/functions/exclude -P /psa/var/

# Permissions
chown -R 1000:1000 "$dlpath/move"
chmod -R 775 "$dlpath/move"

# Remove empty directories
find "$dlpath/move/" -type d -mmin +2 -empty -exec rm -rf {} \;

# Removes garbage
find "$dlpath/downloads" -mindepth 2 -type d -cmin +$cleaner $(printf "! -name %s " $(cat /psa/var/exclude)) -empty -exec rm -rf {} \;
find "$dlpath/downloads" -mindepth 2 -type f -cmin +$cleaner $(printf "! -name %s " $(cat /psa/var/exclude)) -size +1M -exec rm -rf {} \;
