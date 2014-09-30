require 'beaker-rspec/spec_helper'
require 'beaker-rspec/helpers/serverspec'

unless ENV['RS_PROVISION'] == 'no'
  # This will install the latest available package on el and deb based
  # systems fail on windows and osx, and install via gem on other *nixes
  foss_opts = { :default_action => 'gem_install' }

  if default.is_pe?; then install_pe; else install_puppet( foss_opts ); end

  hosts.each do |host|
    if host['platform'] =~ /debian/
      on host, 'echo \'export PATH=/var/lib/gems/1.8/bin/:${PATH}\' >> ~/.bashrc'
    end

    on host, "mkdir -p #{host['distmoduledir']}"
  end
end

UNSUPPORTED_PLATFORMS = ['Suse','windows','AIX','Solaris']

RSpec.configure do |c|
  # Project root
  proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

  # Readable test descriptions
  c.formatter = :documentation

  # Configure all nodes in nodeset
  c.before :suite do
    # Install module and dependencies
    puppet_module_install(:source => proj_root, :module_name => 'profile_passenger')
    hosts.each do |host|
      install_package host, 'git'
      on host, puppet('module', 'install', 'puppetlabs-stdlib'), { :acceptable_exit_codes => [0,1] }
      on host, puppet('module', 'install', 'puppetlabs-apache'), { :acceptable_exit_codes => [0,1] }
      on host, puppet('module', 'install', 'puppetlabs-concat'), { :acceptable_exit_codes => [0,1] }
      on host, puppet('module', 'install', 'puppetlabs-gcc'), { :acceptable_exit_codes => [0,1] }
      on host, shell('cd /etc/puppet/modules && git clone https://github.com/eshamow/puppetlabs-passenger.git passenger && cd /etc/puppet/modules/passenger && git checkout 270bf462a9942f5c534684bef2767cedb98707a0'), { :acceptable_exit_codes => [0,1] }
      on host, shell('cd /etc/puppet/modules && git clone https://github.com/puppetlabs/puppetlabs-ruby.git ruby && cd /etc/puppet/modules/ruby && git checkout d8131b0535c3bb8bc2e72dca5d0b0e6088a65374'), { :acceptable_exit_codes => [0,1] }
    end
  end
end
