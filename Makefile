all:
	echo "vagrant up"

install-vg-plugins:
	echo "=> Install vagrant proxy conf plugin"
	vagrant plugin install vagrant-proxyconf
	echo "=> Install vagrant disksize plugin"
	vagrant plugin install vagrant-disksize

install-rubocop:
	# apt-get install ruby-dev
	gem install --user rubocop

fix:
	rubocop -a Vagrantfile
