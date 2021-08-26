#!/bin/bash


echo "----------------------------"
echo "I: Running devops bootstrap"
if [ ! -e /opt/.bootstrap_devops ]; then

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

  # Run synced bootstrap if exists.
  echo "I: Running /devops/sync/bootstrap.sh if exists"
	if [ -e /devops/sync/bootstrap.sh ]; then
		sudo chmod +x /devops/sync/bootstrap.sh;
		sudo -u vagrant /devops/sync/bootstrap.sh
		echo "I: completed running the /devops/sync/bootstrap.sh"
	fi

  sudo touch /opt/.bootstrap_devops
fi
echo "----------------------------"

exit 0