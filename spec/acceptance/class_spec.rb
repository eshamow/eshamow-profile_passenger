require 'spec_helper_acceptance'

describe 'profile_passenger class', :unless => UNSUPPORTED_PLATFORMS.include?(fact('osfamily')) do
  case fact('osfamily')
  when 'RedHat'
    package_name = 'httpd'
    service_name = 'httpd'
  when 'Debian'
    package_name = 'apache2'
    service_name = 'apache2'
  end

  context 'default parameters' do
    # Using puppet_apply as a helper
    it 'should work idempotently with no errors' do
      pp = <<-EOS
      class { 'profile_passenger': }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes  => true)
    end

    describe package(package_name) do
      it { is_expected.to be_installed }
    end

    describe service(service_name) do
      it { is_expected.to be_enabled }
      it { is_expected.to be_running }
    end
  end
end
