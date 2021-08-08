#!/bin/bash

# https://github.com/theia-ide/theia-apps#theia-docker
sudo docker stop theia-ide
sudo docker rm theia-ide

if [ -e /devops/.theia ]; then
	mkdir /devops/.theia
fi

# Theia documentation https://github.com/theia-ide/theia-apps#theia-docker
sudo docker run -d -it --init \
	--name theia-ide \
	--restart unless-stopped \
	-p 8000:3000 \
	-v "/devops:/home/project:cached" \
	-v "/home/vagrant/.gitconfig:/home/theia/.gitconfig:cached" \
	-v "/home/vagrant/.git-credentials:/home/theia/.git-credentials:cached" \
	-v "/devops/.theia:/home/theia/.theia:cached" \
	theiaide/theia:next
	
exit 0
