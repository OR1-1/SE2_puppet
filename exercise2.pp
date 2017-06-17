node "myhostname" {

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
        unless => 'test -f /home/monitor/scripts/memory_check',
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
