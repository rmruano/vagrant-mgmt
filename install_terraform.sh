#!/bin/bash

if [ ! -e /opt/.terraform_done ]; then
	cd /tmp
	sudo apt-get install unzip
	wget https://releases.hashicorp.com/terraform/1.0.3/terraform_1.0.3_linux_amd64.zip
	unzip terraform_1.0.3_linux_amd64.zip
	sudo chown root:root terraform
	sudo chmod +x terraform
	mv terraform /usr/local/bin

	echo "I: completed installing terraform..... Remember to execute (and paste your token): terraform login"
	touch /opt/.terraform_done
fi

exit 0
