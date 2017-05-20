#! /bin/bash

#Run script to clear .unionfs-fuse folder and remove specified hidden files from ACD since unionfs mounts can't delete files from read-only mount
/bin/bash /home/plex/scripts/clearCache.sh >> /home/plex/scripts/logs/clearCache.log

#Set variables
today=$(date +%Y-%m-%d)
suffix=".mkv"

#Upload to ACD and Google Drive, syncing the individual folder from ACD to Google Drive
#/usr/sbin/rclone move --log-file=/home/plex/scripts/logs/uploadACD.${today}.log /home/plex/.local/RsStxAAoxauX7JdGnbYnyJYc/ acd:Plex/RsStxAAoxauX7JdGnbYnyJYc
#telegram-send "I have just completed uploading $radarr_movie_title to ACD."
#sleep 120s

#/usr/sbin/rclone sync --log-file=/home/plex/scripts/logs/sync.${today}.log "/home/plex/acd/Movies" "Google:Plex/Movies" --exclude *.fuse_hidden* --checkers 20
#telegram-send "I have just completed uploading $radarr_movie_title to Google Drive."
#sleep 120s

##Ucomment lines below if disabling ACD. This will turn GDrive into the preferred uploader. NOTE - Mine is unencrypted.

##Uncomment if GDrive is down
telegram-send "Uploading $radarr_movie_title to Google Drive."
/usr/sbin/rclone move --no-traverse --log-file=/home/plex/scripts/logs/uploadACD.${today}.log /home/plex/local/Movies/ Google:Plex/Movies
telegram-send "Completed uploading $radarr_movie_title to GDrive"

sleep 360s # Sleeping for 5, before Library scan. Adjust to your needs.

# Remove empty directories
find "/home/plex/local/Movies" -mindepth 1 -type d -empty -delete

#Update Plex library
export LD_LIBRARY_PATH=/usr/lib/plexmediaserver
export PLEX_MEDIA_SERVER_APPLICATION_SUPPORT_DIR=/var/lib/plexmediaserver/Library/Application\ Support
/usr/lib/plexmediaserver/Plex\ Media\ Scanner -s -c 3 -d "/home/plex/source/Movies/$radarr_movie_title" #Onlyscans the movie folder.

telegram-send "Plex library update script completed. $radarr_movie_title shall show up shortly!"

exit
