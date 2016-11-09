#!/bin/bash
#Script to install puppet agent on el7

log_file='/var/log/puppet_agent_install_el7.sh.log'
exec > >(tee -a $log_file) 2>&1

puppet_release_package='https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm'
puppet_path='/opt/puppetlabs/puppet/bin'
puppet_package='puppet-agent'

echo "$(date) INFO: Installing puppet..."
sudo rpm -Uvh $puppet_release_package
export PATH=$puppet_path:$PATH
sudo yum install -y $puppet_package 
$puppet_path/gem install r10k

