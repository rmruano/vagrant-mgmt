#!/bin/bash

if [ ! -e /home/vagrant/provision/.git_done ]; then

  #packets
  echo "I: Install pre requisite packages...."
  sudo apt-get install -yq  git

  #gitconfig
  git config --global credential.helper "store --file ~/.git-credentials"
  
  echo "I: Create a flag notifying git configs are done..."
  touch /home/vagrant/provision/.git_done

fi

exit 0
