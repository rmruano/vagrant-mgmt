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
  
  # aliases
  echo 'alias kforward="kubectl port-forward --address 0.0.0.0"' >>~/.bashrc
  echo 'alias kproxy="kubectl proxy --address 0.0.0.0"' >>~/.bashrc
  echo 'alias kdashboard="echo Serving dashboard on https://localhost:8001/ ( How to install: https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/ ) && kforward -n kubernetes-dashboard svc/kubernetes-dashboard 8001:443"' >> ~/.bashrc

  # kubectl-convert
  curl -LO https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl-convert

  # minikube
  #curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
  #sudo install minikube-linux-amd64 /usr/local/bin/minikube
  
  # helm
  wget https://get.helm.sh/helm-v3.6.3-linux-amd64.tar.gz
  tar -xvf helm-v3.6.3-linux-amd64.tar.gz
  rm -Rf helm-v3.6.3-linux-amd64.tar.gz
  sudo mv linux-amd64/helm /usr/local/bin/helm
  rm -Rf linux-amd64
  helm completion bash > helm_completion
  sudo mv helm_completion /etc/bash_completion.d/helm
  echo 'alias h=helm' >>~/.bashrc
  echo 'complete -F __start_helm h' >>~/.bashrc
  

  touch /home/vagrant/provision/.kubernetes_done
fi
echo "----------------------------"
cd -

exit 0