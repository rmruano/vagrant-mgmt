#!/bin/bash

if [ ! -e /home/vagrant/provision/.node_done ]; then
  cd /tmp
  
  sudo apt purge -yq cmdtest
  
  # https://heynode.com/tutorial/install-nodejs-locally-nvm/
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
  source ~/.bashrc
  # Latest
  nvm install --lts --latest-npm --no-progress
  # 14.x
  #nvm install --lts=fermium --latest-npm --no-progress
  # 12.x by default
  nvm install --lts=erbium --latest-npm --no-progress
  # 10.x
  #nvm install --lts=dubnium --latest-npm --no-progress
  # set default
  nvm alias default lts/erbium
  nvm use default
  
  echo "I: Create a flag notifying node configs are done..."
  touch /home/vagrant/provision/.node_done

fi

exit 0
