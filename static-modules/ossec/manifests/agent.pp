# ossec agent setup
class ossec::agent {
  package{'ossec-hids-agent':
    ensure  => present,
    require => Apt::Source['ossec-ubuntu']
  }
}
