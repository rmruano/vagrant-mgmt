#!/bin/bash

if [ ! -e ~/provision/.common_done ]; then

  ln -s /devops ~/devops 
  
  # install base packages
    echo "I: Updating package cache..."
    sudo apt-get update
    echo "I: Install pre requisite packages...."
    sudo apt-get install -yq  python-minimal python-simplejson aptitude screen unzip ntpdate
    sudo apt-get install -yq make dos2unix
	  sudo apt-get install -yq traceroute net-tools tcpdump netstat
	  sudo apt-get install -yq python3-pip

  # merge folders
    sudo cp -pr ~/provision/cfg_overrides/. ~/provision/cfg_defaults/

  # remove overrides, not needed anymore
    rm -Rf ~/provision/cfg_overrides
    mv ~/provision/cfg_defaults ~/provision/cfg
  
  # change working dir, set permissions and remove comments and ignores
    cd ~/provision/cfg
    sudo chown -R vagrant:vagrant ~/provision/cfg
    find ~/provision/cfg/ -type f -name "README.md" -delete
    find ~/provision/cfg/ -type f -name ".gitignore" -delete

  #hosts
    if [ -e hosts ]; then
      echo "I: Copy hosts file to correct systems path.."
      sudo cp -pr hosts /etc/hosts
    sudo chown root:root /etc/hosts
    sudo chmod 664 /etc/hosts
    fi

  #SSL and certificates provisioning
    echo "I: SSL & self-signed root CA provisioning"
    cp -pr ssl ~/
    sudo chmod 640 ~/ssl/*
    sudo chmod 740 ~/ssl
    # Install self signed root ca certificate
    sudo cp -pr ~/ssl/rootCA.pem /usr/local/share/ca-certificates/DevopsMgmt-rootCA.crt
    sudo update-ca-certificates
    sudo chmod 750 ~/ssl/issue-cert-tool.sh
    if [ ! -d ~/ssl/certificates ]; then
      mkdir ~/ssl/certificates
    fi
    sudo chmod 760 ~/ssl/certificates
    sudo chmod -R 660 ~/ssl/certificates/*


  #home
    echo "I: Copy home files"
    rm -Rf ~/provision/cfg/home/README.md
    rm -Rf ~/provision/cfg/home/.gitignore
    sudo dos2unix ~/provision/cfg/home/*
    sudo dos2unix ~/provision/cfg/home/.*
    sudo chmod 600 ~/provision/cfg/home/./* ~/provision/cfg/home/./.[!.]*
    sudo find ~/provision/cfg/home -type d | sudo xargs chmod u+x
    sudo cp -pr ~/provision/cfg/home/. /home/vagrant

  #screen
    mkdir ~/.screen
    sudo chown -R vagrant:vagrant ~/.screen
    sudo chmod 700 ~/.screen
    echo "export SCREENDIR=\$HOME/.screen" >> ~/.bashrc
    echo "PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '" >> ~/.bashrc

  #copy other home directories and set permissions start ---
  echo "I: Copy other home directories start"
  
	  #aws
	  sudo chmod -R 600 ~/provision/cfg/.aws/./* ~/provision/cfg/.aws/./.[!.]*
	  sudo cp -pr .aws ~/
	  
	  #ssh
	  sudo chmod -R 600 ~/provision/cfg/.ssh/./* ~/provision/cfg/.ssh/./.[!.]*
	  sudo cp -pr .ssh ~/
	  #ssh authorized keys
	  if [ -e ~/authorized_keys ]; then
		sudo cat ~/authorized_keys >> ~/.ssh/authorized_keys
		# not required anymore
		sudo rm -Rf ~/authorized_keys
	  fi;
	  
	  #terraform
	  sudo chmod -R 600 ~/provision/cfg/.terraform.d/./* ~/provision/cfg/.terraform.d/./.[!.]*
	  sudo cp -pr .terraform.d ~/
	  
	  #runnable scripts
	  sudo chown -R vagrant:vagrant ~/provision/scripts
	  sudo chmod -R 770 ~/provision/scripts
  
  echo "I: Copy other home directories complete"    
  #copy other home directories and set permissions end ---
  
  # local bin
  mkdir ~/bin
  chmod -R 750 ~/bin
  echo '' >> ~/.bashrc
  echo '# Vagrant custom bin path' >> ~/.bashrc
  echo 'export PATH="$HOME/bin:$PATH"' >> ~/.bashrc
  chmod -R 660 ~/.bashrc


  cd ~/provision
  echo "I: Create a flag notifying common configs are done..."
  touch ~/provision/.common_done

fi

exit 0
