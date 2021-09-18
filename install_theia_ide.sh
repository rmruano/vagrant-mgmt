#!/bin/bash

if [ ! -e /home/vagrant/provision/.theia_ide_done ]; then
	# Theia documentation https://github.com/theia-ide/theia-apps#theia-docker
	#sudo /bin/bash /home/vagrant/provision/scripts/run_theia.sh

	echo "I: completed installing Theia ide..... frontend available at http://localhost:8000"
	touch /home/vagrant/provision/.theia_ide_done
fi

exit 0
