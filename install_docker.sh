#!/bin/bash

if [ ! -e /home/vagrant/provision/.docker_done ]; then
  sudo sudo apt-get update

  # Install Docker
  sudo apt-get install -yq \
    git wget \
      apt-transport-https \
      ca-certificates \
      curl \
      software-properties-common \
      gnupg \
      lsb-release

  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
  echo \
    "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

  sudo apt-get update

  sudo apt-get install -yq docker-ce docker-ce-cli containerd.io

  #docker compose
  sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose >/dev/null 2>&1
  sudo chmod +x /usr/local/bin/docker-compose
  sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

  # add the vagrant user to the docker group
  sudo usermod -aG docker vagrant

  # completion
  sudo curl \
      -L https://raw.githubusercontent.com/docker/compose/1.29.2/contrib/completion/bash/docker-compose \
      -o /etc/bash_completion.d/docker-compose
      
  sudo mkdir /etc/docker
      
  sudo echo '{
	"exec-opts": ["native.cgroupdriver=systemd"],
	"log-driver": "json-file",
	"log-opts": {
	  "max-size": "50m"
	},
	"storage-driver": "overlay2"
}' | sudo tee /etc/docker/daemon.json

  echo "I: completed installing docker and docker-compose....."

	touch /home/vagrant/provision/.docker_done
fi
exit 0
