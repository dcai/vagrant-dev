# vg

- It comes with absolutely no warranty.
- For personal use only, running this software is completely at your own risk.

## Requirements

- Install [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
- Install [Vagrant](https://www.vagrantup.com/downloads.html)


## Use published box

- `mkdir vg`
- `cd vg`
- `vagrant init friendlyrobot/dev`
- `vagrant plugin install vagrant-vbguest` # optional, install vbguest plugin
- `vagrant up`

## Rebuild

 Run following commands in terminal, it creates ubuntu instance and run ansible provision.

- `git clone https://github.com/dcai/vagrant-dev.git vg`
- `cd vg`
- `vagrant plugin install vagrant-vbguest` # install vbguest plugin
- `vagrant up`


## Publish it

- `vagrant package`
- `curl 'https://vagrantcloud.com/api/v1/box/friendlyrobot/dev/version/1.1.0/provider/virtualbox/upload?access_token={ACCESS_TOKEN}'`
- `curl -X PUT --upload-file package.box ${UPLOAD_URL_FROM_LAST_STEP}`
