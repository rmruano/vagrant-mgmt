#!/bin/bash

if [ ! -e /home/vagrant/provision/.common_done ]; then

  ln -s /devops /home/vagrant/devops 
  
  # install base packages
    echo "I: Updating package cache..."
    sudo apt-get update
    echo "I: Install pre requisite packages...."
    sudo apt-get install -yq  python-minimal python-simplejson aptitude screen unzip
    sudo apt-get install -yq make dos2unix

  # merge folders
    sudo cp -pr /home/vagrant/provision/cfg_overrides/. /home/vagrant/provision/cfg_defaults/

  # remove overrides, not needed anymore
    rm -Rf /home/vagrant/provision/cfg_overrides
    mv /home/vagrant/provision/cfg_defaults /home/vagrant/provision/cfg
  
  # change working dir, set permissions and remove comments and ignores
    cd /home/vagrant/provision/cfg
    sudo chown -R vagrant:vagrant /home/vagrant/provision/cfg
    find /home/vagrant/provision/cfg/ -type f -name "README.md" -delete
    find /home/vagrant/provision/cfg/ -type f -name ".gitignore" -delete

  #hosts
    if [ -e hosts ]; then
      echo "I: Copy hosts file to correct systems path.."
      sudo cp -pr hosts /etc/hosts
    sudo chown root:root /etc/hosts
    sudo chmod 664 /etc/hosts
    fi

  #SSL and certificates provisioning
    echo "I: SSL & self-signed root CA provisioning"
    cp -pr ssl /home/vagrant/
    sudo chmod 640 /home/vagrant/ssl/*
    sudo chmod 740 /home/vagrant/ssl
    # Install self signed root ca certificate
    sudo cp -pr /home/vagrant/ssl/rootCA.pem /usr/local/share/ca-certificates/DevopsMgmt-rootCA.crt
    sudo update-ca-certificates
    sudo chmod 750 /home/vagrant/ssl/issue-cert-tool.sh
    if [ ! -d /home/vagrant/ssl/certificates ]; then
      mkdir /home/vagrant/ssl/certificates
    fi
    sudo chmod 760 /home/vagrant/ssl/certificates
    sudo chmod -R 660 /home/vagrant/ssl/certificates/*


  #home
    echo "I: Copy home files"
    rm -Rf /home/vagrant/provision/cfg/home/README.md
    rm -Rf /home/vagrant/provision/cfg/home/.gitignore
    sudo dos2unix /home/vagrant/provision/cfg/home/*
    sudo dos2unix /home/vagrant/provision/cfg/home/.*
    sudo chmod 600 /home/vagrant/provision/cfg/home/./* /home/vagranxitt/provision/cfg/home/./.[!.]*
    sudo find /home/vagrant/provision/cfg/home -type d | sudo xargs chmod u+x
    sudo cp -pr /home/vagrant/provision/cfg/home/. /home/vagrant

  #screen
    mkdir /home/vagrant/.screen
    sudo chown -R vagrant:vagrant /home/vagrant/.screen
    sudo chmod 700 /home/vagrant/.screen
    echo "export SCREENDIR=\$HOME/.screen" >> /home/vagrant/.bashrc
    echo "PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '" >> /home/vagrant/.bashrc

  #copy other home directories and set permissions start ---
  echo "I: Copy other home directories start"
  
	  #aws
	  sudo chmod -R 600 /home/vagrant/provision/cfg/.aws/./* /home/vagrant/provision/cfg/.aws/./.[!.]*
	  sudo cp -pr .aws /home/vagrant/
	  
	  #ssh
	  sudo chmod -R 600 /home/vagrant/provision/cfg/.ssh/./* /home/vagrant/provision/cfg/.ssh/./.[!.]*
	  sudo cp -pr .ssh /home/vagrant/
	  #ssh authorized keys
	  if [ -e /home/vagrant/authorized_keys ]; then
		sudo cat /home/vagrant/authorized_keys >> /home/vagrant/.ssh/authorized_keys
		# not required anymore
		sudo rm -Rf /home/vagrant/authorized_keys
	  fi;
	  
	  #terraform
	  sudo chmod -R 600 /home/vagrant/provision/cfg/.terraform.d/./* /home/vagrant/provision/cfg/.terraform.d/./.[!.]*
	  sudo cp -pr .terraform.d /home/vagrant/
	  
	  #runnable scripts
	  sudo chown -R vagrant:vagrant /home/vagrant/vagrant_scripts
	  sudo chmod -R 770 /home/vagrant/vagrant_scripts
  
  echo "I: Copy other home directories complete"    
  #copy other home directories and set permissions end ---
  
  # local bin
  mkdir /home/vagrant/bin
  chmod -R 750 /home/vagrant/bin
  echo '' >> /home/vagrant/.bashrc
  echo '# Vagrant custom bin path' >> /home/vagrant/.bashrc
  echo 'export PATH="$HOME/bin:$PATH"' >> /home/vagrant/.bashrc
  chmod -R 660 /home/vagrant/.bashrc


  cd /home/vagrant/provision
  echo "I: Create a flag notifying common configs are done..."
  touch /home/vagrant/provision/.common_done

fi

exit 0
