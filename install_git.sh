#!/bin/bash

if [ ! -e /opt/.git_done ]; then

  #packets
  echo "I: Install pre requisite packages...."
  sudo apt-get install -yq  git

  #gitconfig
  if [ -e /tmp/.gitconfig ]; then
    echo "I: Copy .gitconfig"
    sudo mv /tmp/.gitconfig /home/vagrant/.gitconfig
	sudo chown -R vagrant:vagrant /home/vagrant/.gitconfig
  fi  
  
  if [ -e /tmp/.git-credentials ]; then
	echo "I: Copy git credentials"
    sudo mv /tmp/.git-credentials /home/vagrant/.git-credentials-store
  fi  
  sudo git config --global credential.helper "store --file ~/.git-credentials-store"
  
  echo "I: Create a flag notifying git configs are done..."
  touch /opt/.git_done

fi

exit 0
