node "bpx.server.local" {

    exec { 'install vim':
        command => "/usr/bin/yum install vim -y",
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
    
    file { ['/home/monitor/',
            '/home/monitor/scripts/',
            '/home/monitor/src/']:
        ensure => 'directory',
        owner  => 'monitor',
        recurse => true,
        notify => Exec['download memory_check.sh'],
    }

    exec { "download memory_check.sh":
        command     => "/usr/bin/wget -q 'https://raw.githubusercontent.com/OR1-1/SE1_memory_check/dev001/memory_check.sh' -O /home/monitor/scripts/memory_check",
        creates     => "/home/monitor/scripts/memory_check",
        refreshonly => true,
        notify => File['/home/monitor/scripts/memory_check'],
    }
    
    file { '/home/monitor/scripts/memory_check':
        mode   => '755',
        subscribe => Exec['download memory_check.sh']
    }
    
    file { '/home/monitor/src/my_memory_check':
        ensure => 'link',
        target => '/home/monitor/scripts/memory_check',
    }
    
    cron { 'my_memory_check':
        command => '/home/monitor/src/my_memory_check -e l.f@g.c -w 60 -c 90',
        user    => 'root',
        hour    => 0,
        minute  => 10,
    }

    exec { "puppet module install saz-timezone":
        command => "/usr/bin/puppet module install saz-timezone",
    }
    
    #class { 'timezone':
    #    timezone => 'UTC',
    #}
    
    exec { "set hostname to bpx.server.local":
        command => "/bin/hostname bpx.server.local",
    }

}
