# ossec server setup
class ossec::server {
  package{'ossec-hids-server':
    ensure  => present,
    require => Apt::Source['ossec-ubuntu']
  }

}
