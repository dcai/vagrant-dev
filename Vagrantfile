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
RAM = '6144'.freeze
Vagrant.configure('2') do |config|
  config.vm.box = 'friendlyrobot/bionic64'
  # config.disksize.size = '1500GB' if Vagrant.has_plugin?('vagrant-disksize')
  config.vm.box_check_update = false

  config.vm.provider 'virtualbox' do |v, vbox_config|
    vbox_config.vm.network 'public_network', ip: '172.16.0.2'
    ports = (3001..3020).to_a
    ports.push(3306) # mysql
    ports.push(5432) # postgres
    ports.push(8000, 8008, 8080, 8088) # common http
    ports.push(9229) # nodejs inspector port
    ports.each do |port|
      vbox_config.vm.network :forwarded_port, guest: port, host: port
    end
    vbox_config.vm.network 'forwarded_port', guest: 22, host: 2229

    SYNCED_FOLDER['vm']['shares'].each_pair do |_share, share_conf|
      next unless File.exist?(share_conf['host_dir'])

      vbox_config.vm.synced_folder share_conf['host_dir'],
                                   share_conf['vm_mount_point'],
                                   type: share_conf['type']
    end

    disk_file = File.join(VAGRANT_ROOT, '/disk2.vdi')
    unless File.exist?(disk_file)
      v.customize ['createhd', '--filename', disk_file, '--size', 1000 * 1024]
    end
    v.customize ['storageattach', :id,
                 '--storagectl', 'SCSI',
                 '--port', 3,
                 '--device', 0,
                 '--type', 'hdd',
                 '--medium', disk_file]
    v.memory = RAM
    v.gui = GUI_ENABLED
  end

  config.vm.provision 'ansible_local' do |ansible|
    ansible.verbose = 'vvvv'
    ansible.playbook = 'ansible/playbook.yml'
    ansible.inventory_path = 'ansible/inventory-vg.ini'
    ansible.limit = 'all'
  end
end
