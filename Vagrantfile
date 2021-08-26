# -*- mode: ruby -*-
# vi: set ft=ruby :

#print "Please remember to install winnfsd plugin on WINDOWS hosts: vagrant plugin install vagrant-winnfsd"
print "On windows hosts: Please to install VMWARE plugin >>>> vagrant plugin install vagrant-vmware-desktop\n\n"

devopsFolder = ENV["DEVOPS_FOLDER"] || "devops_sync"

print "Using "+devopsFolder+" as /devops\n"
print "You can provide a DEVOPS_FOLDER env var with a different location\n\n"

Vagrant.configure("2") do |config|

  config.vm.box = "generic/ubuntu2104"
  #config.vm.box = "ubuntu/hirsute64"
  config.vm.synced_folder devopsFolder, "/devops/sync", owner: "vagrant", group: "vagrant"
  #config.vm.synced_folder devopsFolder, "/devops", type: "nfs", mount_options: %w{rw,async,fsc,tcp,nolock,vers=3,rsize=32768,wsize=32768,hard,noatime,actimeo=2}

  # files copied
  config.vm.provision "file", source: "scripts", destination: "/home/vagrant/vagrant_scripts"
  config.vm.provision "file", source: "cfg_defaults", destination: "/tmp/cfg_defaults"
  config.vm.provision "file", source: "cfg_overrides", destination: "/tmp/cfg_overrides"
  # common run
  config.vm.define "mgmt" do |node|
    node.vm.hostname = "mgmt"
    node.vm.network:forwarded_port, guest: 22, host: 22 # expose 22 on host available to anyone
    node.vm.network:forwarded_port, guest: 8000, host: 8000, host_ip: "127.0.0.1" # Expose theia ide port only available to localhost
    config.vm.provider :virtualbox do |vb, override|
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