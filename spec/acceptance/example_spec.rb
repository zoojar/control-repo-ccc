require 'spec_helper_acceptance'

describe 'file test' do

  context 'default parameters' do
    # Using puppet_apply as a helper
    it 'should work with no errors based on the example' do
      pp = <<-EOS
        include role::webserver
      EOS

      # Run it twice and test for idempotency
      #expect(apply_manifest(pp).exit_code).to_not eq(1)
      #expect(apply_manifest(pp).exit_code).to eq(0)

      describe file('/etc/puppetlabs/code/environments/production/site/manifests/role/webserver.pp') do
        it { should be_file }
      end

    end

  end
end