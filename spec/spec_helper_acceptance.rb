require 'beaker-rspec/spec_helper'
require 'beaker-rspec/helpers/serverspec'

hosts.each do |host|
  # Install Puppet
  install_puppet
end

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
