#!/bin/sh

echo " Beginning remap. Sleeping for 5 minutes"
sleep 120s


#Unmount any directories already mounted
/bin/fusermount -uz /home/plex/acd
/bin/fusermount -uz /home/plex/.acd
/bin/fusermount -uz /home/plex/.local
/bin/fusermount -uz /home/plex/media
/bin/fusermount -uz /home/plex/local
/bin/fusermount -uz /home/plex/source

#Mount ACD using rClone
/usr/sbin/rclone mount acd:Plex /home/plex/.acd &
/usr/sbin/rclone mount Google:Plex /home/plex/source &

#Mount encryption over these folders
ENCFS6_CONFIG='/home/plex/encfs.xml' encfs --extpass="cat /home/plex/scripts/encfspass" /home/plex/.acd /home/plex/acd
ENCFS6_CONFIG='/home/plex/encfs.xml' encfs --extpass="cat /home/plex/scripts/encfspass" /home/plex/.local /home/plex/local

#Use union-fs to merge our remote and local directories
unionfs-fuse -o cow /home/plex/local=RW:/home/plex/acd=RO /home/plex/media

exit
