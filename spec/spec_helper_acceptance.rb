require 'beaker-rspec'
require 'beaker/puppet_install_helper'

run_puppet_install_helper

UNSUPPORTED_PLATFORMS = ['windows','Solaris','Darwin']

RSpec.configure do |c|
  # Project root
  proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

  # Readable test descriptions
  c.formatter = :documentation

  # Configure all nodes in nodeset
  c.before :suite do
    # Install module and dependencies
    puppet_module_install(:source => proj_root, :module_name => 'consul')
    hosts.each do |host|
      # Needed for the consul module to download the binary per the modulefile
      on host, puppet('module', 'install', 'puppetlabs-stdlibby'), { :acceptable_exit_codes => [0,1] }
      on host, puppet('module', 'install', 'nanliu/staging'), { :acceptable_exit_codes => [0,1] }
    end
  end
end