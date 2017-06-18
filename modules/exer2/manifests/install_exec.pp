class exer2::install_exec inherits exer2 {

  exec { 'install vim':
    command => "/usr/bin/yum install vim -y",
  }

}
