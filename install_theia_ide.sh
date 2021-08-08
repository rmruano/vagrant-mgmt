#!/bin/bash

if [ ! -e /opt/.theia_ide ]; then	
	# Theia documentation https://github.com/theia-ide/theia-apps#theia-docker
	sudo /bin/bash /home/vagrant/vagrant_scripts/run_theia.sh

	echo "I: completed installing Theia ide..... frontend available at http://localhost:8000"
	touch /opt/.theia_ide
fi

exit 0
