class exer2::dirfiles (
  $dirs,
  $owner,
  $link,
  $target,
  $shurl

) inherits exer2 {

  file { $dirs:
    ensure  => 'directory',
    owner   => $owner,
    recurse => true,
  }

  exec { "download memory_check.sh":
    command => "/usr/bin/wget -q '$shurl' -O /root/memory_check",
  }

  file { $target:
    ensure => 'present',
    owner  => 'monitor',
    mode   => '755',
    source => "/root/memory_check",
  }
  
  file { $link:
    ensure => 'link',
    target => $target,
  }

}
