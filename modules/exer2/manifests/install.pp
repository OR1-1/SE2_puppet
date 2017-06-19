class exer2::install inherits exer2 {

  package { 'curl':
    ensure => present,
  }

  package { 'git':
    ensure => present,
  }

  package { 'wget':
    ensure => present,
  }
}
