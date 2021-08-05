#!/bin/bash

if [ ! -e /opt/.common_done ]; then

  ln -s /devops /home/vagrant/devops 
  
  echo "I: Updating package cache..."
  sudo apt-get update

  #packets
  echo "I: Install pre requisite packages...."
  sudo apt-get install -yq  python-minimal python-simplejson aptitude screen

  #hosts
  if [ -e /tmp/hosts ]; then
    echo "I: Copy hosts file to correct systems path.."
    sudo cp /tmp/hosts /etc/hosts
  fi
  
  #ssh
  echo "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAvEH2o4mKp7Jrbhgvo7JDSEhw+RUZHLJ59SSUTiRTu9DkrpvvZrQs4YXAStkw9zSsvhJp3kQ/86n16SMA/p12KC9Kr9PeGovXJQMkQjnvYNXmYWiMA9g3ubQ7YCMZWbzIS6aKXc8ujP4Au3RNTcBinPgZorLkMvKlm9EphjRZSLuyBZ+0TLNBA7DHmYGu3Rd69q2rosoWMabsKS/NC9U8JX64P/hXsc68wP4OhSMxQzqf4suGJtBLZHk4R6wr4j+TVwEbDdlD5fL6Vaty7Rf7+ZNeMeYSLhyC1CwyYFEgfmJ1KzBivKGGnnY1hNzHe5Kn39TLeOPJJMs1upLM/6rTUQ== ruben.moraleda.ruano@gmail.com" >> /home/vagrant/.ssh/authorized_keys
  sudo chown -R vagrant:vagrant /home/vagrant/.ssh/*
  sudo chmod 600 /home/vagrant/.ssh/*
  
  #screen
  sudo chmod 600 /home/vagrant/.screenrc

  echo "I: Create a flag notifying common configs are done..."
  touch /opt/.common_done

fi

exit 0
