require 'spec_helper_acceptance'

describe 'file test' do

  context 'default parameters' do
    # Using puppet_apply as a helper
    describe file('/etc/puppetlabs/code/environments/production/site/manifests/role/webserver.pp') do
      it { should be_file }
    end
  end
end