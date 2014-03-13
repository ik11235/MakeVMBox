echo "config.berkshelf.enabled = true">Vagrantfile
echo "config.vm.provision :chef_solo do |chef|">>Vagrantfile
echo "chef.run_list = [">>Vagrantfile
for Recipe in "${SELECTBOOKS[@]}";
do
    echo "\"recipe[${Recipe}]\"" >>Vagrantfile
done
echo "] end" >>Vagrantfile
