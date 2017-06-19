class exer2::systemconfig inherits exer2 {

  exec { "change timezone":
    command => "/bin/rm -rf /etc/localtime && /bin/ln -s /usr/share/zoneinfo/Asia/Manila /etc/localtime",
  }
  
  exec { "set hostname to bpx.server.local":
    command => "/bin/hostname bpx.server.local",
    notify  => Exec['edit network'],
  }
  
  exec { "edit network":
    command => "/bin/sed -i \'/HOSTNAME/c\\HOSTNAME=bpx.server.local\' /etc/sysconfig/network",
    refreshonly => true,
    onlyif => '/bin/grep -iq HOSTNAME /etc/sysconfig/network',
    notify  => Exec['append network'],
  }
  
  exec { "append network":
    command => "/bin/echo HOSTNAME=bpx.server.local >> /etc/sysconfig/network",
    refreshonly => true,
    unless => '/bin/grep -iq HOSTNAME /etc/sysconfig/network',
    notify  => Exec['edit resolv.conf'],
  }
  
  exec { "edit resolv.conf":
    command => "/bin/sed -i \'/domain/c\\domain server.local\' /etc/resolv.conf",
    refreshonly => true,
    onlyif => '/bin/grep -iq domain /etc/resolv.conf',
    notify  => Exec['append resolv.conf'],
  }
  
  exec { "append resolv.conf":
    command => "/bin/echo domain server.local >> /etc/resolv.conf",
    refreshonly => true,
    unless => '/bin/grep -iq domain /etc/resolv.conf',
  }

}
