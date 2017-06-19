class exer2::dirfiles inherits exer2 {

  file { ['/home/monitor/',
          '/home/monitor/scripts/',
          '/home/monitor/src/']:
    ensure  => 'directory',
    owner   => 'monitor',
    recurse => true,
    notify  => Exec['download memory_check.sh'],
  }

  exec { "download memory_check.sh":
    command     => "/usr/bin/wget -q 'https://raw.githubusercontent.com/OR1-1/SE1_memory_check/master/memory_check.sh' -O /home/monitor/scripts/memory_check",
    creates     => "/home/monitor/scripts/memory_check",
    refreshonly => true,
    unless      => '/usr/bin/test -f /home/monitor/scripts/memory_check',
    notify      => File['/home/monitor/scripts/memory_check'],
  }
  
  file { '/home/monitor/scripts/memory_check':
    mode      => '755',
    subscribe => Exec['download memory_check.sh']
  }
  
  file { '/home/monitor/src/my_memory_check':
    ensure => 'link',
    target => '/home/monitor/scripts/memory_check',
  }

}
