#!/bin/bash

if [ ! -e /opt/.common_done ]; then

  ln -s /devops /home/vagrant/devops 
  
  # install base packages
  echo "I: Updating package cache..."
  sudo apt-get update
  echo "I: Install pre requisite packages...."
  sudo apt-get install -yq  python-minimal python-simplejson aptitude screen unzip dos2unix

  # merge folders
  sudo cp -pr /tmp/cfg_overrides/. /tmp/cfg_defaults/
  
  # change working dir, set permissions and remove comments and ignores
  cd /tmp/cfg_defaults
  sudo chown -R vagrant:vagrant /tmp/cfg_defaults
  find /tmp/cfg_defaults/ -type f -name "README.md" -delete
  find /tmp/cfg_defaults/ -type f -name ".gitignore" -delete

  #hosts
  if [ -e hosts ]; then 
    echo "I: Copy hosts file to correct systems path.."
    sudo cp -pr hosts /etc/hosts
	sudo chown root:root /etc/hosts
	sudo chmod 664 /etc/hosts
  fi
  
  #home
  echo "I: Copy home files"
  
  rm -Rf /tmp/cfg_defaults/home/README.md
  rm -Rf /tmp/cfg_defaults/home/.gitignore
  sudo chmod 600 /tmp/cfg_defaults/home/./* /tmp/cfg_defaults/home/./.[!.]*
  sudo cp -pr /tmp/cfg_defaults/home/. /home/vagrant
  
  #copy other home directories and set permissions start ---
  echo "I: Copy other home directories start"
  
	  #aws
	  sudo chmod -R 600 /tmp/cfg_defaults/.aws/./* /tmp/cfg_defaults/.aws/./.[!.]*
	  sudo cp -pr .aws /home/vagrant/.aws
	  
	  #ssh
	  sudo chmod -R 600 /tmp/cfg_defaults/.ssh/./* /tmp/cfg_defaults/.ssh/./.[!.]*
	  sudo cp -pr .ssh /home/vagrant/.ssh
	  #ssh authorized keys
	  if [ -e /home/vagrant/authorized_keys ]; then
		sudo cat /home/vagrant/authorized_keys >> /home/vagrant/.ssh/authorized_keys
		# not required anymore
		sudo rm -Rf /home/vagrant/authorized_keys
	  fi;
	  
	  #terraform
	  sudo chmod -R 600 /tmp/cfg_defaults/.terraform.d/./* /tmp/cfg_defaults/.terraform.d/./.[!.]* 
	  sudo cp -pr .terraform.d /home/vagrant/.terraform.d
	  
	  #runnable scripts
	  sudo chown -R vagrant:vagrant /home/vagrant/vagrant_scripts
	  sudo chmod -R 770 /home/vagrant/vagrant_scripts
  
  echo "I: Copy other home directories complete"    
  #copy other home directories and set permissions end ---
  
  # remove tmp files
  rm -Rf /tmp/cfg_defaults
  rm -Rf /tmp/cfg_overrides
  cd /tmp

  echo "I: Create a flag notifying common configs are done..."
  touch /opt/.common_done

fi

exit 0
