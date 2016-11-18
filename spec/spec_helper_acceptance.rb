require 'beaker-rspec'
require 'beaker/puppet_install_helper'

run_puppet_install_helper

UNSUPPORTED_PLATFORMS = ['windows','Solaris','Darwin']

# Determine control repo url and branch from jenkins env vars...
R10K_REMOTE           = "#{ENV['GIT_URL']}" 
R10K_BRANCH           = "#{"#{ENV['GIT_BRANCH']}".slice! "origin/"}"
r10k_pp = <<EOD
class { 'r10k':
  sources           => {
    'puppet' => {
        'remote'  => '#{R10K_REMOTE}',
        'basedir' => "\${::settings::confdir}/environments",
        'prefix'  => false,
    }
  },
}
EOD



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
      create_remote_file(host, '/tmp/r10k.pp', r10k_pp)
      on host, puppet('apply', '/tmp/r10k.pp')
      on host, "r10k deploy environment -p -v"
    end
  end
end