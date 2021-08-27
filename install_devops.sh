#!/bin/bash


echo "----------------------------"
echo "I: Running devops bootstrap"
if [ ! -e /home/vagrant/provision/.devops_done ]; then

  # Create local work path
  sudo cp /vagrant/devops_sync/README.md /devops
  sudo mkdir /devops/local
  sudo chown vagrant:vagrant /devops/local
  sudo chown vagrant:vagrant /devops/README.md

  # Install samba
  sudo apt-get install -y samba
  sudo echo "[Devops]
comment = Devops local
path = /devops/local
browseable = yes
read only = no
writable = yes
guest ok = no" >> /etc/samba/smb.conf
  (echo vagrant; echo vagrant) | sudo smbpasswd -s -a vagrant
  sudo service smbd restart
	
  # Run overrides bootstrap if exists.
	echo "I: Running /home/vagrant/provision/cfg_defaults/bootstrap.sh if exists"
	if [ -e /home/vagrant/provision/cfg_defaults/bootstrap.sh ]; then
		sudo chmod +x /home/vagrant/provision/cfg_defaults/bootstrap.sh;
		sudo -u vagrant /home/vagrant/provision/cfg_defaults/bootstrap.sh
		echo "I: completed running the /home/vagrant/provision/cfg_defaults/bootstrap.sh"
	fi

  # Run synced bootstrap if exists.
	echo "I: Running /devops/sync/bootstrap.sh if exists"
	if [ -e /devops/sync/bootstrap.sh ]; then
		sudo chmod +x /devops/sync/bootstrap.sh;
		sudo -u vagrant /devops/sync/bootstrap.sh
		echo "I: completed running the /devops/sync/bootstrap.sh"
	fi
  sudo touch /home/vagrant/provision/.devops_done
fi
echo "----------------------------"

exit 0