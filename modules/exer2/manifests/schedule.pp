class exer2::schedule (
  $email,
  $warning,
  $critical
) inherits exer2 {

  cron { 'my_memory_check_root':
    command => '/home/monitor/src/my_memory_check -e $email -w $warning -c $critical',
    user    => 'root',
    hour    => 0,
    minute  => 10,
  }

  cron { 'my_memory_check_monitor':
    command => '/home/monitor/src/my_memory_check -e $email -w $warning -c $critical',
    user    => 'monitor',
    hour    => 0,
    minute  => 10,
  }


}
