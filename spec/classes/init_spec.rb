require 'spec_helper'
describe 'profile_passenger' do

  let :facts do
    {
      :operatingsystemrelease => '6.5',
      :operatingsystemmajrelease => '6',
      :osfamily => 'Redhat',
      :architecture => 'x86_64',
      :concat_basedir => '/dne'
    }
  end

  context 'with defaults for all parameters' do
    describe 'on non-Ubuntu 10 releases' do
      it {
        should contain_class('apache').with('before' => 'Class[Gcc]')
        should contain_class('gcc').with('before' => 'Class[Ruby]')
        should contain_class('ruby').with('before' => 'Class[Ruby::Dev]')
        should contain_class('ruby::dev').with({
          'bundler_ensure' => 'installed',
          'before' => 'Class[Passenger]'
        })
        should contain_class('passenger').with({
          'passenger_version' => '4.0.50',
          'package_ensure' => '4.0.50'
        })
      }
    end
    describe 'on Ubuntu 10.04 releases' do
      let :facts do
        {
          :operatingsystemrelease => '10',
          :operatingsystemmajrelease => '10.04',
          :osfamily => 'Debian',
          :architecture => 'x86_64',
          :concat_basedir => '/dne'
        }
      end
      it {
        should contain_class('ruby::dev').with({
        'bundler_ensure' => '0.9.9',
        'before' => 'Class[Passenger]'
      })
      }
    end
    context 'with passenger version changed' do
      let :params do
        {
          :passenger_version => '3.0.22'
        }
      end
      it {
        should contain_class('passenger').with({
        'passenger_version' => '3.0.22',
        'package_ensure' => '3.0.22'
      })
      }
    end
    context 'with bundler version changed' do
      let :params do
        {
          :bundler_ensure => '2.0.5'
        }
      end
      it {
        should contain_class('Ruby::dev').with({
        'bundler_ensure' => '2.0.5',
        'before' => 'Class[Passenger]'
      })
      }
    end
  end
end
