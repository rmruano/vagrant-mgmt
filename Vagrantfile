# -*- mode: ruby -*-
# vi: set ft=ruby :

devopsFolder = ENV["DEVOPS_FOLDER"] || "devops_sync"

print "Using "+devopsFolder+" as /devops\n"
print "You can provide a DEVOPS_FOLDER env var with a different location\n\n"

Vagrant.configure("2") do |config|

  config.vm.box = "ubuntu/hirsute64"
  config.vm.synced_folder devopsFolder, "/devops", owner: "vagrant", group: "vagrant"
  # files copied
  config.vm.provision "file", source: "scripts", destination: "/home/vagrant/vagrant_scripts"
  config.vm.provision "file", source: "cfg_defaults", destination: "/tmp/cfg_defaults"
  config.vm.provision "file", source: "cfg_overrides", destination: "/tmp/cfg_overrides"
  # common run
  config.vm.define "mgmt" do |node|
    node.vm.hostname = "mgmt"
    node.vm.network "private_network", ip: "192.168.90.140", nic_type: "virtio"
    node.vm.network:forwarded_port, guest: 22, host: 22 # expose 22 on host available to anyone
	node.vm.network:forwarded_port, guest: 8000, host: 8000, host_ip: "127.0.0.1" # Expose theia ide port only available to localhost
    config.vm.provider :virtualbox do |vb|
       vb.customize ["modifyvm", :id, "--memory", "4096"]
       vb.customize ["modifyvm", :id, "--cpus", "4"]
       vb.customize ['modifyvm', :id, '--natdnsproxy1', 'off' ]
       vb.customize ['modifyvm', :id, '--natdnshostresolver1', 'off']
    end
    node.vm.provision "shell", path: "install_common.sh"
    node.vm.provision "shell", path: "install_git.sh"
    node.vm.provision "shell", path: "install_docker.sh"
    node.vm.provision "shell", path: "install_awscli.sh"
    node.vm.provision "shell", path: "install_terraform.sh"
    node.vm.provision "shell", path: "install_theia_ide.sh"
    node.vm.provision "shell", path: "bootstrap_devops.sh"
    node.vm.provision "shell", path: "bootstrap_versioncheck.sh"
  end

end