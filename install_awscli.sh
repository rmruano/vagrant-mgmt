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
	echo /usr/local/bin/aws --version
    touch /opt/.aws_done
fi

if [ ! -e /home/vagrant/.aws/id_rsa ]; then
	echo "I: generating a new management key pair....."
	ssh-keygen -b 4096 -t rsa -f /home/vagrant/.aws/id_rsa -q -N ""
else
	echo "I: management key pair found at /home/vagrant/.aws/id_rsa ....."
fi

exit 0 
