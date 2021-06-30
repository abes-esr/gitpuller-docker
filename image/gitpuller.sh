#!/bin/bash

# Git pull stuff
if [ ! -d /folder-to-git-pull/.git/ ]; then
       	echo "--> $(date '+%Y-%m-%d %H:%M:%S') - Error: git pull not possible because /folder-to-git-pull/ is not a git clone result"
	sleep 2 && exit 1
else
	echo "--> $(date '+%Y-%m-%d %H:%M:%S') - Update /folder-to-git-pull/ with a git pull"
	git -C /folder-to-git-pull/ pull
fi
