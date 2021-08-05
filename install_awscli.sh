#!/bin/bash

if [ ! -e /opt/.aws_done ]; then
	cd /tmp
	sudo curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
	unzip awscliv2.zip
	sudo ./aws/install
	mv ./aws /home/vagrant/
	sudo chown -R vagrant:vagrant /home/vagrant/aws

	sudo chown -R vagrant:vagrant /home/vagrant/.aws
	sudo chmod -R 700 /home/vagrant/.aws
	  
	echo "I: completed installing AWS CLI....."
    touch /opt/.aws_done
fi

exit 0
