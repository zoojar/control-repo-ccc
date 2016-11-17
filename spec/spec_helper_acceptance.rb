require 'beaker-rspec'
require 'beaker/puppet_install_helper'

run_puppet_install_helper

UNSUPPORTED_PLATFORMS = ['windows','Solaris','Darwin']
R10K_REMOTE           = "#{ENV[GIT_URL]}" 

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
      pp = <<-EOS
        class { 'r10k':
          remote => '#{R10K_REMOTE}',
        }
      EOS
      on host, apply_manifest(pp)
    end
  end
end