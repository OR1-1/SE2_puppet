class exer2::schedule inherits exer2 {

  cron { 'my_memory_check':
    command => '/home/monitor/src/my_memory_check -e l.f@g.c -w 60 -c 90',
    user    => 'root',
    hour    => 0,
    minute  => 10,
  }

}
