#!/bin/bash

if [ ! -e /opt/.common_done ]; then

  ln -s /devops /home/vagrant/devops 
  
  echo "I: Updating package cache..."
  sudo apt-get update

  #packets
  echo "I: Install pre requisite packages...."
  sudo apt-get install -yq  python-minimal python-simplejson aptitude screen unzip dos2unix

  #hosts
  if [ -e /tmp/hosts ]; then
    echo "I: Copy hosts file to correct systems path.."
    sudo cp /tmp/hosts /etc/hosts
  fi
  
  #ssh
  if [ -e /tmp/authorized_keys ]; then
	sudo cat /tmp/authorized_keys >> /home/vagrant/.ssh/authorized_keys
  fi;
  sudo chown -R vagrant:vagrant /home/vagrant/.ssh/*
  sudo chmod 600 /home/vagrant/.ssh/*
  
  #screen
  if [ -e /tmp/.screenrc ]; then
    sudo cp /tmp/.screenrc /home/vagrant/.screenrc
	sudo chown -R vagrant:vagrant /home/vagrant/.screenrc
	sudo chmod 600 /home/vagrant/.screenrc
	dos2unix /home/vagrant/.screenrc
  fi;

  echo "I: Create a flag notifying common configs are done..."
  touch /opt/.common_done

fi

exit 0
