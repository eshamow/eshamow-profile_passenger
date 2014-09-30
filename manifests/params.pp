# == Class: profile_passenger::params
#
class profile_passenger::params {
  $passenger_version = '4.0.50'
  if $::osfamily == 'debian' and $::operatingsystemmajrelease == '10.04' {
    $bundler_ensure = '0.9.9'
  } else {
    $bundler_ensure = 'installed'
  }
}
