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
  $graphite_url = 'demo',
  $dashboards = [
    {
      name        =>'Demo',
      refresh     => 5000,
      description => '#Giraffe : A [Graphite](http://graphite.wikidot.com) Dashboard with a long neck <img class=\'pull-right\' src=\'img/giraffe.png\' />\n\n<br/>\n<a class=\'btn btn-large btn-warning\' href=\'https://github.com/kenhub/giraffe\'><i class=\'icon-github icon-large\'></i> View project on github</a>\n\n##More?\n\nCheck out the different dashboards for more information about riding giraffes.',
      metrics     =>
      [
        {
          alias             => 'signups',
          target            => 'sumSeries(enter.your.graphite.metrics.here)',
          description       => 'New signups to the website',
          summary           => 'sum',
          summary_formatter => 'd3.format(\',f\')',
        },
        {
          alias         => 'signup breakdown',
          targets       => [
            'sumSeries(enter.your.graphite.metrics.here)',
            'sumSeries(enter.another.graphite.metrics)',
          ],
          description   => 'signup breakdown based on site location',
          renderer      => 'area',
          unstack       => true,
        },
        {
          alias           => 'Registration breakdown',
          target          => 'sumSeries(enter.your.graphite.metrics.here)',
          target          =>  'function() { return \'summarize(events.registration.success,\'\' + entire_period() + \'min)\' }',
          renderer        => 'bar',
          description     => 'Registrations based on channel',
          hover_formatter => 'd3.format(\'03.6g\')',
          null_as         => 0,
        },
      ]
    },
  ],
) {

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
  }

}
