#!/bin/bash
find /home/plex/media/.unionfs-fuse -name '*_HIDDEN~' | while read line; do
oldPath=${line#/home/plex/source/.unionfs-fuse}
newPath=/home/plex/acd${oldPath%_HIDDEN~}
rm "$newPath"
rm "$line"
done
find "/home/plex/source/.unionfs-fuse" -mindepth 1 -type d -empty -delete
exit