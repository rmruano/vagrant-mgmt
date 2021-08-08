#!/bin/bash

if [ ! -e /opt/.aws_done ]; then
	cd /tmp
	sudo apt-get install -yq unzip
	sudo curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
	unzip -q awscliv2.zip
	sudo ./aws/install
	mv ./aws /home/vagrant/aws-cli
	sudo chown -R vagrant:vagrant /home/vagrant/aws-cli
	  
	echo "I: completed installing AWS CLI....."
	echo /usr/local/bin/aws --versionva
    touch /opt/.aws_done
fi

exit 0 
