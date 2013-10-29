# setting up analogi
class ossec::analogi {

  package{['apache2', 'php5', 'libapache2-mod-php5', 'php5-mysql', 'git-core']:
    ensure  => present
  }

  git::clone {'analogi':
    url   => 'git://github.com/ECSC/analogi.git',
    dst   => '/var/www/analogi',
  } ->

  file { '/var/www/analogi/db_ossec.php':
    mode    => '0644',
    content => template('ossec/db_ossec.php.erb'),
    owner   => root,
    group   => root,
  }
}
