#!/bin/bash

echo "----------------------------"
echo "I: Running /devops/bootstrap.sh if exists"
if [ ! -e /opt/.bootstrap_devops ]; then	
	if [ -e /devops/bootstrap.sh ]; then	
		sudo chmod +x /devops/bootstrap.sh;
		/devops/bootstrap.sh
		echo "I: completed runing the /devops/bootstrap.sh"
		sudo touch /opt/.bootstrap_devops
	fi
fi
echo "----------------------------"

exit 0