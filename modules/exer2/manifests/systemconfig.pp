class exer2::systemconfig (
  $timezonepath,
  $fqdn,
  $domain
) inherits exer2 {

  exec { "change timezone":
    command => "/bin/rm -rf /etc/localtime && /bin/ln -s $timezonepath /etc/localtime",
  }
  
  exec { "set hostname to $fqdn":
    command => "/bin/hostname $fqdn",
    notify  => Exec['edit network'],
  }
  
  exec { "edit network":
    command => "/bin/sed -i \'/HOSTNAME/c\\HOSTNAME=$fqdn\' /etc/sysconfig/network",
    refreshonly => true,
    onlyif => '/bin/grep -iq HOSTNAME /etc/sysconfig/network',
    notify  => Exec['append network'],
  }
  
  exec { "append network":
    command => "/bin/echo HOSTNAME=$fqdn >> /etc/sysconfig/network",
    refreshonly => true,
    unless => '/bin/grep -iq HOSTNAME /etc/sysconfig/network',
    notify  => Exec['edit resolv.conf'],
  }
  
  exec { "edit resolv.conf":
    command => "/bin/sed -i \'/domain/c\\domain $domain\' /etc/resolv.conf",
    refreshonly => true,
    onlyif => '/bin/grep -iq domain /etc/resolv.conf',
    notify  => Exec['append resolv.conf'],
  }
  
  exec { "append resolv.conf":
    command => "/bin/echo domain $domain >> /etc/resolv.conf",
    refreshonly => true,
    unless => '/bin/grep -iq domain /etc/resolv.conf',
  }

}
