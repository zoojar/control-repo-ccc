#!/bin/bash
#Script to install puppet agent on el7
# Pass optional argument for a url to download r10k.yaml

r10k_yaml_url=$1

puppet_release_package='https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm'
puppet_path='/opt/puppetlabs/puppet/bin'
puppet_package='puppet-agent'

echo "$(date) INFO: Installing puppet..."
sudo rpm -Uvh $puppet_release_package
export PATH=$puppet_path:$PATH
sudo yum install -y $puppet_package 

regex='(https?|ftp|file)://[-A-Za-z0-9\+&@#/%?=~_|!:,.;]*[-A-Za-z0-9\+&@#/%=~_|]'

if [[ $r10k_yaml_url =~ $regex ]] ; then 
  echo "$(date) INFO: Installing r10k and running a deploy from ${r10k_yaml_url}..."
  $puppet_path/gem install r10k
  yum -y install git
  cd /etc/puppetlabs/puppet
  curl $r10k_yaml_url > r10k.yaml
  r10k deploy environment -v
fi
