class exer2::user ( 
  $username,
  $home,
  $shell
) inherits exer2 {

  user { $username:
    ensure => 'present',
    home   => $home,
    shell  => $shell,
  }

}
