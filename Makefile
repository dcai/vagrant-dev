all:
	vagrant plugin install vagrant-vbguest

install-plugins:
	vagrant plugin install vagrant-proxyconf
	vagrant plugin install vagrant-disksize

install-rubocop:
	# apt-get install ruby-dev
	gem install --user rubocop

fix:
	rubocop -a Vagrantfile
