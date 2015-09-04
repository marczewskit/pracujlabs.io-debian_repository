Vagrant.configure("2") do |config|

  config.vm.box = "puppetlabs/ubuntu-12.04-64-puppet"

  config.vm.provider "virtualbox" do |vb|
      vb.customize ["modifyvm", :id, "--memory", "1048"]
      vb.customize ["modifyvm", :id, "--cpus", "1"]
  end


  config.vm.provision "puppet" do |puppet|

  puppet.module_path = "modules"
    puppet.environment_path = "environments"
    puppet.environment = "testenv"
    puppet.hiera_config_path = "hiera.yaml"
  end

  config.vm.define :server do |server|
    server.vm.network :private_network, ip: "172.16.10.201"
    server.vm.hostname = "server"
  end

  config.vm.define :client do |client|
      client.vm.network :private_network, ip: "172.16.10.202"
      client.vm.hostname = "client"
    end
end
