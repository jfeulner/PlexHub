#! /bin/bash

#Run script to clear .unionfs-fuse folder and remove specified hidden files from ACD since unionfs mounts can't delete files from read-only mount
/bin/bash /home/plex/scripts/clearCache.sh >> /home/plex/scripts/logs/clearCache.log


#Set variables
today=$(date +%Y-%m-%d)
suffix=".mkv"

#Upload to ACD and Google Drive, syncing the individual folder from ACD to Google Drive
telegram-send "Starting to upload  $sonarr_series_title season $sonarr_episodefile_seasonnumber to ACD."
echo "Uploading to ACD"
/usr/sbin/rclone move --log-file=/home/plex/scripts/logs/uploadACD.${today}.log /home/plex/.local/dYd0BjOcDD332suc5vEtc7mg/ acd:Plex/dYd0BjOcDD332suc5vEtc7mg --size-only
telegram-send "I have just completed uploading a $sonarr_series_title season $sonarr_episodefile_seasonnumber to ACD. Waiting for Sync"
sleep 120s


telegram-send "Starting to upload  $sonarr_series_title season $sonarr_episodefile_seasonnumber to Google Drive."
echo "Uploading to Google Drive"
/usr/sbin/rclone sync --log-file=/home/plex/scripts/logs/sync.${today}.log "/home/plex/acd/Shows/$sonarr_series_title/Season $sonarr_episodefile_seasonnumber" "Google:Plex/Shows/$sonarr_series_title/Season $sonarr_episodefile_seasonnumber" --exclude *.fuse_hidden* --checkers 20

telegram-send "I have just completed uploading a $sonarr_Series_title season $sonarr_episodefile_seasonnumber episode $sonarr_episodefile_scenename to Google Drive."

sleep 120s

# Remove empty directories
find "/home/plex/local/Shows" -mindepth 1 -type d -empty -delete

export LD_LIBRARY_PATH=/usr/lib/plexmediaserver
export PLEX_MEDIA_SERVER_APPLICATION_SUPPORT_DIR=/var/lib/plexmediaserver/Library/Application\ Support
/usr/lib/plexmediaserver/Plex\ Media\ Scanner -s -c 2 -d "/home/plex/source/Shows/$sonarr_series_title/Season $sonarr_episodefile_seasonnumber"
 telegram-send "Plex library scan complete"
 exit
