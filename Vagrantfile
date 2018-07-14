# vim: set ft=ruby:
require 'yaml'

## Change working directory to the location of Vagrantfile
Dir.chdir(File.dirname(__FILE__))

VAGRANT_ROOT = File.dirname(File.expand_path(__FILE__))
GUI_ENABLED = false
if ARGV.include?('--gui')
  ARGV.delete('--gui')
  GUI_ENABLED = true
end

SYNCED_FOLDER = if Vagrant::Util::Platform.windows?
                  YAML.load_file 'conf/shares-win.yaml'
                else
                  YAML.load_file 'conf/shares.yaml'
                end

Vagrant.configure('2') do |config|
  config.disksize.size = '100GB' if Vagrant.has_plugin?('vagrant-disksize')
  config.vm.box = 'ubuntu/xenial64'
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

  config.vm.provider 'virtualbox' do |v|
    disk_file = File.join(VAGRANT_ROOT, '/hdd/dev.vdi')
    unless File.exist?(disk_file)
      v.customize ['createhd', '--filename', disk_file, '--size', 500 * 1024]
    end
    v.customize ['storageattach', :id,
                 '--storagectl', 'SCSI',
                 '--port', 3,
                 '--device', 0,
                 '--type', 'hdd',
                 '--medium', disk_file]
    v.memory = '4096'
    v.gui = GUI_ENABLED

    SYNCED_FOLDER['vm']['shares'].each_pair do |_share, share_conf|
      next unless File.exist?(share_conf['host_dir'])
      config.vm.synced_folder share_conf['host_dir'],
                              share_conf['vm_mount_point'],
                              type: share_conf['type']
    end
  end

  config.vm.provision 'ansible_local' do |ansible|
    ansible.verbose = 'vvvv'
    ansible.playbook = 'ansible/playbook.yml'
    ansible.inventory_path = 'ansible/inventory-vg.ini'
    ansible.limit = 'all'
  end
end
