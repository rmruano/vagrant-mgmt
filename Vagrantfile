# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.box = "ubuntu/xenial64"
  config.vm.synced_folder "../", "/devops"
  # files copied
  config.vm.provision "file", source: "config", destination: "/tmp"
  config.vm.provision "file", source: ".ssh", destination: "/home/vagrant/.ssh"
  config.vm.provision "file", source: ".aws", destination: "/home/vagrant/.aws"
  config.vm.provision "file", source: "scripts", destination: "/home/vagrant/scripts"
  config.vm.provision "file", source: ".terraform.d", destination: "/home/vagrant/.terraform.d"
  # common run
  config.vm.provision "shell", path: "install_common.sh"
  config.vm.define "mgmt" do |node|
    node.vm.hostname = "mgmt"
    node.vm.network "private_network", ip: "192.168.45.10"
	node.vm.network:forwarded_port, guest: 8000, host: 8000, host_ip: "127.0.0.1" #theia ide port only available to localhost
    config.vm.provider :virtualbox do |vb|
       vb.customize ["modifyvm", :id, "--memory", "2048"]
       vb.customize ["modifyvm", :id, "--cpus", "2"]
    end
    node.vm.provision "shell", path: "install_git.sh"
    node.vm.provision "shell", path: "install_docker.sh"
    node.vm.provision "shell", path: "install_awscli.sh"
    node.vm.provision "shell", path: "install_terraform.sh"
    node.vm.provision "shell", path: "install_theia_ide.sh"
  end

end