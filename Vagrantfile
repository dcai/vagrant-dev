# vim: set ft=ruby:
require 'yaml'

## Change working directory to the location of Vagrantfile
Dir.chdir(File.dirname(__FILE__))

GUI_ENABLED = false
if ARGV.include?('--gui')
  ARGV.delete('--gui')
  GUI_ENABLED = true
end

if Vagrant::Util::Platform.windows?
  SYNCED_FOLDER = YAML.load_file 'vagrant/conf/config-win.yaml'
else
  SYNCED_FOLDER = YAML.load_file 'vagrant/conf/config.yaml'
end

Vagrant.configure('2') do |config|
  config.disksize.size = '100GB' if Vagrant.has_plugin?('vagrant-disksize')
  config.vm.box = 'ubuntu/xenial64'

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  config.vm.box_check_update = false

  config.vm.network 'private_network', ip: '172.16.0.2'

  ## Proxy settings
  # if Vagrant.has_plugin?("vagrant-proxyconf")
  # config.proxy.http     = "http://192.168.0.2:3128/"
  # config.proxy.https    = "http://192.168.0.2:3128/"
  # config.proxy.no_proxy = "localhost,127.0.0.1,.example.com"
  # end

  ports = (3000..3020).to_a
  ports.push(3306) # mysql
  ports.push(5432) # postgres
  ports.push(8000, 8080) # common http
  ports.push(9229) # nodejs inspector port
  ports.each do |port|
    config.vm.network :forwarded_port, guest: port, host: port
  end
  config.vm.network 'forwarded_port', guest: 22, host: 2229

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  config.vm.provider 'virtualbox' do |v|
    # Display the VirtualBox GUI when booting the machine
    # vb.gui = true
    # Customize the amount of memory on the VM:
    v.memory = '4096'
    v.gui = GUI_ENABLED

    SYNCED_FOLDER['vm']['shares'].each_pair do |_share, share_conf|
      if File.exist?(share_conf['host_dir'])
        config.vm.synced_folder share_conf['host_dir'],
                                share_conf['vm_mount_point'],
                                type: share_conf['type']
      end
    end
  end

  config.vm.provision 'ansible_local' do |ansible|
    ansible.verbose = 'vvvv'
    ansible.playbook = 'ansible/playbook.yml'
    ansible.inventory_path = 'ansible/inventory-vg.ini'
    ansible.limit = 'all'
  end
end
