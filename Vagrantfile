#-*- mode: ruby -*-
# vi: set ft=ruby :
#

#$my_ip                        = "#{(`facter ipaddress`).gsub(/\n/,"")}"
$puppet_log                   = '/var/log/puppetlabs/puppet_apply.log'
$r10k_yaml_url                = "https://raw.githubusercontent.com/zoojar/control-repo-ccc/production/r10k.yaml"                   
$agent_install_script         = "https://raw.githubusercontent.com/zoojar/control-repo-ccc/production/scripts/puppet_agent_install_el7.sh"
$domain                       = 'lab.local'
$disable_firewall             = 'systemctl stop firewalld && systemctl disable firewalld'
$install_puppet               = "curl #{$agent_install_script} > install.sh && . install.sh #{$r10k_yaml_url}"
$masterless_deploy            = "#{$disable_firewall} && #{$install_puppet}"
  # "dump hieradata and facts here before puppet runs"



nodes = [
  { 
    :hostname        => 'sandpit', 
    :domain          => $domain,
    :ip              => '192.168.100.99', 
    :box             => 'centos/7', 
    :ram             => 3000,
    :cpus            => 4,
    :cpuexecutioncap => 90,
    :shell_script    => "#{$masterless_deploy} && puppet apply -l #{$puppet_log} --environment=${1} -e \"include role::${2}\" ; tail #{$puppet_log}",
    :shell_args      => ['consul_cluster','webserver'], # [ 'Environment', 'Role' ]
  },
]

Vagrant.configure("2") do |config|
  nodes.each do |node|
    config.vm.define node[:hostname] do |nodeconfig|
      nodeconfig.vm.box      = node[:box]
      nodeconfig.vm.hostname = node[:domain] ? "#{node[:hostname]}.#{node[:domain]}" : "#{node[:hostname]}" ;
      memory                 = node[:ram] ? node[:ram] : 1000 ; 
      cpus                   = node[:cpus] ? node[:cpus] : 2 ;
      cpuexecutioncap        = node[:cpuexecutioncap] ? node[:cpuexecutioncap] : 50 ;
      nodeconfig.vm.network :private_network, ip: node[:ip]
      nodeconfig.vm.provider :virtualbox do |vb|
        vb.customize [
          "modifyvm", :id,
          "--memory", memory.to_s,
          "--cpus", cpus.to_s,
          "--cpuexecutioncap", cpuexecutioncap.to_s,
        ] 
      end
      #nodeconfig.vm.provision :reload
      nodeconfig.vm.provision "shell" do | s |
        s.inline     = node[:shell_script]
        s.args       = node[:shell_args]
        s.keep_color = true
      end
    end
  end
end





