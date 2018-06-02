all:
	echo "=> Install vagrant nfs guest plugin"
	vagrant plugin install vagrant-nfs_guest
	echo "=> Install vagrant proxy conf plugin"
	vagrant plugin install vagrant-proxyconf
	echo "=> Install vagrant disksize plugin"
	vagrant plugin install vagrant-disksize
fix:
	rubocop -a Vagrantfile
