#!/bin/bash

if [ ! -e /opt/.theia_ide ]; then	
	# Theia documentation https://github.com/theia-ide/theia-apps#theia-docker
	dos2unix /home/vagrant/scripts/run_theia.sh
	sudo /bin/bash /home/vagrant/scripts/run_theia.sh

	echo "I: completed installing theia ide..... available at http://localhost:8000"
	touch /opt/.theia_ide
fi

exit 0
