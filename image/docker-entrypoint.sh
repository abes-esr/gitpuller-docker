#!/bin/bash

# initialize default values for parameters
export GIT_AS_UID=${GIT_AS_UID:='0'}
export GIT_AS_GID=${GIT_AS_GID:='0'}

env >> /etc/environment

# vérification de la présence du git clone initial
if [ ! -d /folder-to-git-pull/.git/ ]; then
  echo "Error: do not start gitpuller because /folder-to-git-pull/ is not a already clonned git folder" 
  sleep 2 && exit 1
fi

# create real linux user (named gitpuller) if necessary
# sudo will us it tu run git pull
grep ":${GIT_AS_GID}:" /etc/group >/dev/null
if [ $? -eq 1 ]; then
  echo "groupadd --gid ${GIT_AS_GID} gitpuller"
  groupadd --gid ${GIT_AS_GID} gitpuller
fi
grep ":${GIT_AS_UID}:" /etc/passwd >/dev/null
if [ $? -eq 1 ]; then
  echo "useradd --uid ${GIT_AS_UID} -g ${GIT_AS_GID} gitpuller"
  useradd --uid ${GIT_AS_UID} -g ${GIT_AS_GID} gitpuller
fi

# to be ok with git clone with ssh auth
mkdir -p /root/.ssh/
echo "Host *" > /root/.ssh/config && echo "StrictHostKeyChecking no" >> /root/.ssh/config
if [ -f /root/.ssh/id_rsa.orig ]; then
  cp -f /root/.ssh/id_rsa.orig /root/.ssh/id_rsa
  cp -f /root/.ssh/id_rsa.pub.orig /root/.ssh/id_rsa.pub
  chmod 600 /root/.ssh/id_rsa
  chmod 644 /root/.ssh/id_rsa.pub
  if [ $GIT_AS_UID != "0" ]; then
    mkdir -p /home/gitpuller/.ssh/
    cp -f /root/.ssh/* /home/gitpuller/.ssh/
    chown -R gitpuller:gitpuller /home/gitpuller/.ssh/
  fi
  echo "SSH key found for git (.ssh/id_rsa is ready)"
else
  echo "No SSH key found for git (skip .ssh/ setup)"
fi

# start gitpuller for a first time
/usr/local/bin/gitpuller.sh >/proc/1/fd/1 2>/proc/1/fd/2

# execute CMD (crond)
exec "$@"
