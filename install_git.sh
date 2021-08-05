#!/bin/bash

if [ ! -e /opt/.git_done ]; then

  #packets
  echo "I: Install pre requisite packages...."
  sudo apt-get install -yq  git

  # 1 year login cache
  git config --global credential.helper 'cache --timeout=31536000'

  echo "I: Create a flag notifying git configs are done..."
  touch /opt/.git_done

fi

exit 0
