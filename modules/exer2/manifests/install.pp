class exer2::install ($packages) inherits exer2 {

  package { $packages:
    ensure => present,
    allow_virtual => true,
  }

}
