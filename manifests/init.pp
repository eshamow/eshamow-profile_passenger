# == Class: profile_passenger
#
# Installs a full and opinionated Apache/Passenger stack.
#
# === Parameters
#
# [*passenger_version*]
#   Version of passenger to install. Defaults to 4.0.50
#
# [*bundler_ensure*]
#   Version of bundler to install. Defaults to 'installed' except for on
#   Ubuntu 10.04, where it defaults to '0.9.9'
#
# === Examples
#
#  class { 'profile_passenger':
#    passenger_version => '3.0.20',
#  }
#
# === Authors
#
# Eric Shamow <eric.shamow@gmail.com>
#
# === Copyright
#
# Copyright 2014 Eric Shamow
#
class profile_passenger(
  $passenger_version = $profile_passenger::params::passenger_version,
  $bundler_ensure    = $profile_passenger::params::bundler_ensure
) inherits profile_passenger::params {
  class { 'apache': } ->
  class { 'gcc': } ->
  class { 'ruby': } ->
  class { 'ruby::dev':
    bundler_ensure => $bundler_ensure,
  } ->
  class { 'passenger':
    passenger_version => $passenger_version,
    package_ensure    => $passenger_version,
  }
}
