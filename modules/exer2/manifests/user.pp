class exer2::user inherits exer2 {

  user { 'monitor':
    ensure => 'present',
    home   => '/home/monitor',
    shell  => '/bin/bash',
  }

}
