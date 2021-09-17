#!/bin/bash


echo "----------------------------"
echo "I: Running bootstrap"
if [ ! -e /home/vagrant/provision/.bootstrap_done ]; then
 	
  # Run overrides bootstrap if exists ---------------------------------------
	echo "I: Running /home/vagrant/provision/cfg_defaults/bootstrap.sh if exists"
	if [ -e /home/vagrant/provision/cfg_defaults/bootstrap.sh ]; then
		sudo chmod +x /home/vagrant/provision/cfg_defaults/bootstrap.sh;
		sudo -u vagrant /home/vagrant/provision/cfg_defaults/bootstrap.sh
		echo "I: completed running the /home/vagrant/provision/cfg_defaults/bootstrap.sh"
	fi
	
	sudo touch /home/vagrant/provision/.bootstrap_done
  
fi
echo "----------------------------"

exit 0