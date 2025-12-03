# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/jammy64"
  
  config.vm.provider "virtualbox" do |vb|
    vb.name = "notesapp-kubernetes"
    vb.memory = "4096"
    vb.cpus = 2
  end
  
  config.vm.network "forwarded_port", guest: 80, host: 8080
  config.vm.network "forwarded_port", guest: 443, host: 8443
  config.vm.hostname = "notesapp-vm"
  
  config.vm.synced_folder ".", "/vagrant"
  
  config.vm.provision "shell", inline: <<-SHELL
    apt-get update
    apt-get install -y python3 python3-pip
  SHELL
  
  config.vm.provision "ansible_local" do |ansible|
    ansible.playbook = "provisioning/site.yml"
    ansible.install = true
    ansible.compatibility_mode = "2.0"
    ansible.extra_vars = {
      dockerhub_username: "souff1159"
    }
  end
end