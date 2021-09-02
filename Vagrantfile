# -*- mode: ruby -*-
# vi: set ft=ruby :

print "On windows hosts: Shared folders are painfully slow, at the current time, samba shared folders are the best option performance-wise\n\n"

devopsFolder = ENV["DEVOPS_FOLDER"] || "devops_sync"

print "Using "+devopsFolder+" as /devops\n"
print "You can provide a DEVOPS_FOLDER env var with a different location\n\n"

Vagrant.configure("2") do |config|

  config.vm.box = "generic/ubuntu2104"
  config.vm.synced_folder devopsFolder, "/devops/sync", owner: "vagrant", group: "vagrant"
  #config.vm.synced_folder devopsFolder, "/devops/sync", type: "smb", owner: "vagrant", group: "vagrant"

  # files copied
  config.vm.provision "file", source: "scripts", destination: "/home/vagrant/provision/scripts"
  config.vm.provision "file", source: "cfg_defaults", destination: "/home/vagrant/provision/cfg_defaults"
  config.vm.provision "file", source: "cfg_overrides", destination: "/home/vagrant/provision/cfg_overrides"
  # common run
  config.vm.define "mgmt" do |node|
    node.vm.hostname = "mgmt"
    node.vm.network "private_network", ip: "192.168.90.140"
    node.vm.network:forwarded_port, guest: 22, host: 1122 # expose 1122 on host available to anyone
    #node.vm.network:forwarded_port, guest: 8000, host: 8000, host_ip: "127.0.0.1" # Expose theia ide port only available to localhost
    config.vm.provider :virtualbox do |vb, override|
       override.vm.box = "ubuntu/hirsute64"
       override.vm.network "private_network", ip: "192.168.90.140", nic_type: "virtio"
       vb.customize ["modifyvm", :id, "--memory", "4096"]
       vb.customize ["modifyvm", :id, "--cpus", "4"]
       vb.customize ['modifyvm', :id, '--natdnsproxy1', 'off' ]
       vb.customize ['modifyvm', :id, '--natdnshostresolver1', 'off']
    end
    config.vm.provider "vmware_desktop" do |vw, override|
       override.vm.network "private_network", ip: "192.168.80.140"
       vw.vmx["memsize"] = "4096"
       vw.vmx["numvcpus"] = "4"
    end
    config.vm.provider "hyperv" do |hv, override|
       hv.vmx["memsize"] = "4096"
       hv.vmx["numvcpus"] = "4"
    end
    node.vm.provision "shell", path: "install_common.sh"
    node.vm.provision "shell", path: "install_git.sh"
    node.vm.provision "shell", path: "install_node.sh"
    node.vm.provision "shell", path: "install_docker.sh"
    node.vm.provision "shell", path: "install_awscli.sh"
    node.vm.provision "shell", path: "install_terraform.sh"
    node.vm.provision "shell", path: "install_kubernetes.sh"
    node.vm.provision "shell", path: "install_theia_ide.sh"
    node.vm.provision "shell", path: "install_devops.sh"
    node.vm.provision "shell", path: "bootstrap_versioncheck.sh"
  end

end