#!/bin/bash

env >> /etc/environment

# vérification de la présence du git clone initial
if [ ! -d /folder-to-git-pull/.git/ ]; then
  echo "Error: do not start gitpuller because /folder-to-git-pull/ is not a already clonned git folder" 
  sleep 2 && exit 1
fi

# to be ok with git clone with ssh auth
if [ -f /root/.ssh/id_rsa.orig ]; then
  cp -f /root/.ssh/id_rsa.orig /root/.ssh/id_rsa
  cp -f /root/.ssh/id_rsa.pub.orig /root/.ssh/id_rsa.pub
  chmod 600 /root/.ssh/id_rsa
  chmod 644 /root/.ssh/id_rsa.pub
  echo "SSH key found for git (.ssh/id_rsa is ready)"
else
  echo "No SSH key found for git (skip .ssh/ setup)"
fi

# start gitpuller for a first time
/usr/local/bin/gitpuller.sh >/proc/1/fd/1 2>/proc/1/fd/2

# execute CMD (crond)
exec "$@"
