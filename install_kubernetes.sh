#!/bin/bash


echo "----------------------------"
echo "I: Running kubernetes tools installation"
cd /tmp
if [ ! -e /home/vagrant/provision/.kubernetes_done ]; then
  curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
  sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

  # autocompletion
  kubectl completion bash > /tmp/bash_completion.kubectl
  sudo cp /tmp/bash_completion.kubectl /etc/bash_completion.d/kubectl
  rm /tmp/bash_completion.kubectl
  echo 'alias k=kubectl' >>~/.bashrc
  echo 'complete -F __start_kubectl k' >>~/.bashrc

  # kubectl-convert
  curl -LO https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl-convert

  # minikube
  curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
  sudo install minikube-linux-amd64 /usr/local/bin/minikube

  touch /home/vagrant/provision/.kubernetes_done
fi
echo "----------------------------"
cd -

exit 0