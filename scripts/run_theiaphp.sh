#!/bin/bash

# https://github.com/theia-ide/theia-apps#theia-docker
sudo docker stop theia-ide-php
sudo docker rm theia-ide-php

if [ -e $HOME/.theiaphp ]; then
	mkdir $HOME/.theiaphp
fi

# Theia documentation https://github.com/theia-ide/theia-apps#theia-docker
docker run -d -it --init \
	--name theia-ide-php \
	--user $(id -u) \
	--restart unless-stopped \
	-e "PHPLS_ALLOW_XDEBUG=2.6.1" \
	-p 8000:3000 \
	-v "/devops:/home/project:cached" \
	-v "$HOME/.gitconfig:/home/theia/.gitconfig:cached" \
	-v "$HOME/.git-credentials:/home/theia/.git-credentials:cached" \
	-v "$HOME/.theiaphp:/home/theia/.theia:cached" \
	theiaide/theia-php:next
	
exit 0
