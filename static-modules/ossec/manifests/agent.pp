# ossec agent setup
class ossec::agent($server_ip='') {
  apt::source { 'ossec-ubuntu':
    location    => 'http://ppa.launchpad.net/nicolas-zin/ossec-ubuntu/ubuntu',
    release     => 'precise',
    repos       => 'main',
    key         => '0C4FF926',
    key_server  => 'keyserver.ubuntu.com',
  }

  package{'ossec-hids-agent':
    ensure  => present,
    require => Apt::Source['ossec-ubuntu']
  }

  file { '/var/ossec/etc/ossec.conf':
    ensure  => file,
    mode    => '0440',
    content => template('ossec/agent-ossec.conf.erb'),
    owner   => ossec,
    group   => ossec,
    require => Package['ossec-hids-agent']
  } ~>

  service{'ossec-hids-agent':
    ensure    => running,
    enable    => true,
    hasstatus => true,
  }
}
