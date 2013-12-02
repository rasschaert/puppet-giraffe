puppet-giraffe
==============

This is a Puppet module for [kenhub/giraffe](https://github.com/kenhub/giraffe). Giraffe is a pretty straightforward project and so is this module.  
It assumes you have packaged giraffe. A quick explanation of how to package giraffe using [fpm](https://github.com/jordansissel/fpm) can be found [here](https://github.com/kenhub/giraffe/issues/37#issuecomment-29371388).

Usage
-----
*Just the default demo dashboards*
```puppet
include 'giraffe'
```

*Specify your own dashboards and metrics*
```puppet
class { 'giraffe':
  graphite_url => 'http://graphite.example.com',
  dashboards   => [
    {
      name        =>'Dashboard 1',
      refresh     => 10000,
      description => 'Load dashboard',
      metrics     =>
      [
        {
          alias             => 'Long-term loads',
          targets           => [
            'box1.box1_example_com.load.load.longterm',
            'box2.box2_example_com.load.load.longterm',
          ],
          description       => 'The long-term loads of boxes 1 and 2',
        },
        {
          alias         => 'Mid-term load box1',
          target        => 'box1.box1_example_com.load.load.midterm',
          description   => 'second metric',
        },
      ],
    },
  ],
}
```

*Using hiera as your data backend*
```puppet
class { 'giraffe':
  graphite_url => hiera('graphite_url'),
  dashboards   => hiera('giraffe_dashboards'),
}
```

```yaml
---
graphite_url: 'http://graphite.example.com'

giraffe_dashboards:
  - name: 'Dashboard 1'
    refresh: 10000
    description: 'Load dashboard'
    metrics:
      - alias: 'Long-term loads'
        targets:
        - 'box1.box1_example_com.load.load.longterm'
        - 'box2.box2_example_com.load.load.longterm'
        description: 'The long-term loads of boxes 1 and 2'
      - alias: 'Mid-term load box1'
        target: 'box1.box1_example_com.load.load.midterm'
        description: 'The mid-term load of box1'
      - alias: 'Mid-term load box2'
        target: 'box2.box2_example_com.load.load.midterm'
        description: 'The mid-term load of box2'
  - name: 'Dashboard 2'
    description: 'Memory dashboard'
    metrics:
      - alias: 'Free memory box1'
        target: 'box1.box1_example_com.memory.memory.free.value'
        description: 'free memory of box1'
      - alias: 'Free memory box2'
        target: 'box2.box2_example_com.memory.memory.free.value'
        description: 'free memory of box2'
```

License
-------
MIT

Contact
-------
kenny@kennyrasschaert.be

