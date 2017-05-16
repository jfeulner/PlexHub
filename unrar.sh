#!/bin/bash
formats=(zip rar)
commands=([zip]="unzip -u" [rar]="unrar -o- e")
extraction_subdir='extracted'

torrentid=$1
torrentname=$2
torrentpath=$3

log()
		{
		logger -t deluge-extractarchives "$@"
		}

log "Torrent complete: $@"
	cd "${torrentpath}"
		for format in "${formats[@]}"; do
		while read file; do
log "Extracting \"$file\""
	cd "$(dirname "$file")"
	file=$(basename "$file")
# if extraction_subdir is not empty, extract to subdirectory
	if [[ ! -z "$extraction_subdir" ]] ; then
		mkdir "$extraction_subdir"
		cd "$extraction_subdir"
		file="../$file"
	fi
	${commands[$format]} "$file"
	done < <(find "$torrentpath/$torrentname" -iname "*.${format}" )