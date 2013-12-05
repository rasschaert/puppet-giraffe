# Class: giraffe::params
# Default parameters for the giraffe class
#
class giraffe::params {
  $graphite_url    = 'demo'
  $override_scheme = false
  $scheme          = 'spectrum14'
  $dashboards      = [
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
  ]
}
