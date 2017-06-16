node "c67.localdomain.com" {

    package { 'vim':
        ensure => present,
    }

    package { 'curl':
        ensure => present,
    }

    package { 'git':
        ensure => present,
    }

    user { 'monitor':
        ensure => 'present',
        home   => '/home/monitor',
        shell  => '/bin/bash',
    }
    
    file { '/home/monitor/scripts/':
        ensure => 'directory',
        owner  => 'monitor',
    }

    exec { "download https://raw.githubusercontent.com/OR1-1/SE1_memory_check/dev001/memory_check.sh":
        command => "wget -q 'https://raw.githubusercontent.com/OR1-1/SE1_memory_check/dev001/memory_check.sh' -O /home/monitor/scripts/memory_check",
        require => Package[ "wget" ],
    }

    file { '/home/monitor/src/':
        ensure => 'directory',
        owner  => 'monitor',
    }
    
    file { '/home/monitor/src/my_memory_check':
        ensure => 'link',
        target => '/home/monitor/scripts/memory_check',
    }
    
    cron { 'my_memory_check':
        command => '/home/monitor/src/my_memory_check',
        user    => 'root',
        hour    => 0,
        minute  => 10,
    }

    exec { "puppet module install saz-timezone":
        command => "puppet module install saz-timezone",
    }
    
    class { 'timezone':
        timezone => 'UTC',
    }
    
    exec { "set hostname to bpx.server.local":
        command => "hostname bpx.server.local",
    }

}
