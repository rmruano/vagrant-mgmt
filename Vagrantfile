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
    node.vm.network "private_network", ip: "192.168.2.2"
    node.vm.network:forwarded_port, guest: 22, host: 1122, host_ip: "127.0.0.1" # expose 1122 on host available to localhost
    node.vm.network:forwarded_port, guest: 8000, host: 8000, host_ip: "127.0.0.1" # Expose theia ide port only available to localhost
    node.vm.network:forwarded_port, guest: 8080, host: 8080, host_ip: "127.0.0.1" # Convenience port
	node.vm.network:forwarded_port, guest: 8443, host: 8443, host_ip: "127.0.0.1" # Convenience port
    node.vm.network:forwarded_port, guest: 8001, host: 8001, host_ip: "127.0.0.1" # Kproxy & kportforward
    config.vm.provider :virtualbox do |vb, override|
       override.vm.box = "ubuntu/hirsute64"
       override.vm.network "private_network", ip: "192.168.2.2", nic_type: "virtio"
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
    node.vm.provision "shell", path: "install_common.sh", privileged: false
    node.vm.provision "shell", path: "install_git.sh", privileged: false
    node.vm.provision "shell", path: "install_node.sh", privileged: false
    node.vm.provision "shell", path: "install_docker.sh", privileged: false
    node.vm.provision "shell", path: "install_awscli.sh", privileged: false
    node.vm.provision "shell", path: "install_terraform.sh", privileged: false
    node.vm.provision "shell", path: "install_kubernetes.sh", privileged: false
    node.vm.provision "shell", path: "install_theia_ide.sh", privileged: false
    node.vm.provision "shell", path: "install_devops.sh", privileged: false
    node.vm.provision "shell", path: "install_bootstrap.sh", privileged: false
    node.vm.provision "shell", path: "versioncheck.sh", privileged: false
  end

end