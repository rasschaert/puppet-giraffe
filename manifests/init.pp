# == Class: giraffe
#
# Full description of class giraffe here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { giraffe:
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Kenny Rasschaert <kenny@kennyrasschaert.be>
#
# === Copyright
#
# Copyright 2013 Kenny Rasschaert, unless otherwise noted.
#
class giraffe (
  $graphite_url    = $::giraffe::params::graphite_url,
  $override_scheme = $::giraffe::params::override_scheme,
  $scheme          = $::giraffe::params::scheme,
  $dashboards      = $::giraffe::params::dashboards,
) inherits giraffe::params {

  package { 'giraffe':
    ensure  => present,
    require => Package['httpd'],
  }

  $documentroot = $::osfamily ? {
    'RedHat'  => '/var/www/html',
    'FreeBSD' => '/usr/local/www/apache22/data',
    default   => '/var/www',
  }

  $apacheuser = $::osfamily ? {
    'Debian'  => 'www-data',
    'FreeBSD' => 'www',
    default   => 'apache',
  }

  file { "${::giraffe::documentroot}/giraffe/dashboards.js":
    ensure  => file,
    owner   => $::giraffe::apacheuser,
    content => template('giraffe/dashboards.js.erb'),
    require => Package['giraffe'],
  }

}
