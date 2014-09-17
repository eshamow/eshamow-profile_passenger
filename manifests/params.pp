class profile_passenger::params {
  $passenger_version = '4.0.50'
  if $::osfamily == 'debian' and $::operatingsystemmajrelease == '10.04' {
    $bundler_ensure = '1.6.6'
  } else {
    $bundler_ensure = 'installed'
  }
}
