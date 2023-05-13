#!/bin/bash

if [[ $EUID -eq 0 ]]; then                                                                                                                                                                   
   echo "This script must be run as a non-root user!"                                                                                                                                                    
   exit 1                                                                                                                                                                                    
fi                     

function log() {
	echo "[INFO] $1"
}

#################################################
# Install abs minimums
#################################################

log "Installing minimum packages"
sudo apt update && sudo apt install -y \
	openssh-server \
	openssh-client \
	ansible \
	apt-transport-https

#################################################
# Setup SSH
#################################################

echo
echo 
log "Starting SSH setup"

if [[ ! -f ~/.ssh/id_rsa ]]; then
	log "Creating ssh key"
	ssh-keygen -f ~/.ssh/id_rsa -N "" -q
else
	log "Ssh key already exist"
fi

mkdir -p ~/.ssh
touch ~/.ssh/authorized_keys
PUB_KEY=`cat ~/.ssh/id_rsa.pub`
if ! grep -q "$PUB_KEY" ~/.ssh/authorized_keys; then
	log "Adding ssh key to authorized keys"
	cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
else
	log "Ssh key already added to authorized keys"
fi

touch ~/.ssh/known_hosts
FINGER=`ssh-keyscan -t rsa localhost 2>&1`
if ! grep -q "$FINGER" ~/.ssh/known_hosts; then
	log "Adding ssh fingerprint to known hosts"
	echo "$FINGER" >> ~/.ssh/known_hosts
else
	log "Ssh fingerprint already added to known hosts"
fi

dest_user=`grep dest_user hosts.yml | awk '{ print $2 }'`
if ! sudo grep -q "$dest_user" /etc/sudoers; then
	log "Adding $dest_user to sudoers"
	echo "$dest_user ALL=(ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers > /dev/null
else
	log "Already added $dest_user to sudoers"
fi

