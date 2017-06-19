node default {

  class { 'exer2::install':
    packages => ['git', 'wget', 'curl', 'vim-enhanced']
  }

  class { 'exer2::user':
    username => 'monitor',
    home     => '/home/monitor',
    shell    => '/bin/bash',
  }

  class { 'exer2::dirfiles':
    dirs  => ['/home/monitor/', '/home/monitor/scripts/', '/home/monitor/src/'],
    owner => 'monitor',
    link  => '/home/monitor/src/my_memory_check',
    target => '/home/monitor/scripts/memory_check',
    shurl => 'https://raw.githubusercontent.com/OR1-1/SE1_memory_check/master/memory_check.sh',
  }

  class { 'exer2::schedule':
    email    => 'l.f@g.c',
    warning  => '60',
    critical => '90',
  }

  class { 'exer2::systemconfig':
    timezonepath => '/usr/share/zoneinfo/Asia/Manila',
    fqdn         => 'bpx.server.local',
    domain       => 'server.local',
  }

}
