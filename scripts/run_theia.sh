#!/bin/bash

# https://github.com/theia-ide/theia-apps#theia-docker
sudo docker stop theia-ide
sudo docker rm theia-ide

if [ -e /devops/sync/.theia ]; then
	mkdir /devops/sync/.theia
fi

# Theia documentation https://github.com/theia-ide/theia-apps#theia-docker
docker run -d -it --init \
	--name theia-ide \
	--user $(id -u) \
	--restart unless-stopped \
	-p 8000:3000 \
	-v "/devops:/home/project:cached" \
	-v "$HOME/.gitconfig:/home/theia/.gitconfig:cached" \
	-v "$HOME/.git-credentials:/home/theia/.git-credentials:cached" \
	-v "/devops/sync/.theia:/home/theia/.theia:cached" \
	theiaide/theia:next
	
exit 0
