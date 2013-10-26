# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure("2") do |config|

  bridge = ENV['VAGRANT_BRIDGE']
  bridge ||= 'eth0'
  env  = ENV['PUPPET_ENV']
  env ||= 'dev'

  config.vm.define :ossecserver do |server|
    server.vm.box = 'ubuntu-13.04_puppet-3.3.1' 
    server.vm.network :public_network, :bridge => bridge
    server.vm.hostname = 'ossec-server.local'

    server.vm.provider :virtualbox do |vb|
      vb.customize ['modifyvm', :id, '--memory', 2048, '--cpus', 2]
    end

    server.vm.provision :puppet do |puppet|
      puppet.manifests_path = 'manifests'
      puppet.manifest_file  = 'default.pp'
      puppet.options = '--modulepath=/vagrant/modules:/vagrant/static-modules --hiera_config /vagrant/hiera_vagrant.yaml --environment=#{env}'

    end
  end

  config.vm.define :ossecagent do |agent|
    agent.vm.box = 'ubuntu-13.04_puppet-3.3.1' 
    agent.vm.network :public_network, :bridge => bridge
    agent.vm.hostname = 'ossec-agent.local'

    agent.vm.provider :virtualbox do |vb|
      vb.customize ['modifyvm', :id, '--memory', 2048, '--cpus', 2]
    end

    agent.vm.provision :puppet do |puppet|
      puppet.manifests_path = 'manifests'
      puppet.manifest_file  = 'default.pp'
      puppet.options = '--modulepath=/vagrant/modules:/vagrant/static-modules --hiera_config /vagrant/hiera_vagrant.yaml --environment=#{env}'

    end
  end


end
