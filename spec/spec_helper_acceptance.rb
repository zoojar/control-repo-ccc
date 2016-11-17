require 'beaker-rspec'
require 'beaker/puppet_install_helper'

run_puppet_install_helper

UNSUPPORTED_PLATFORMS = ['windows','Solaris','Darwin']

# Determine control repo url and branch from jenkins env vars...
R10K_REMOTE           = "#{ENV['GIT_URL']}" 
R10K_BRANCH           = "#{"#{ENV['GIT_BRANCH']}".slice! "origin/"}"

RSpec.configure do |c|
  # Project root
  proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

  # Readable test descriptions
  c.formatter = :documentation

  # Configure all nodes in nodeset
  c.before :suite do
    # Install module and dependencies
    hosts.each do |host|
      on host, puppet('module', 'install', 'zack-r10k', '--version', '3.2.0' ), { :acceptable_exit_codes => [0] }
      pp = "\"class { \'r10k\': remote => \'#{R10K_REMOTE}\',}\""
      on host, puppet('apply', '-e', pp)
      on host, "r10k deploy environment #{R10K_BRANCH} -v"
    end
  end
end