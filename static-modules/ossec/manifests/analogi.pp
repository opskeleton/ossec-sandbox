# setting up analogi
class ossec::analogi($dbuser='', $dbpass='', $dbhost=''){

  package{['apache2', 'php5', 'php5-mysql']:
    ensure  => present
  } ->

  git::clone {'analogi':
    url     => 'git://github.com/ECSC/analogi.git',
    dst     => '/var/www/analogi/',
    owner   => root,
    require => Package['apache2']
  } ->

  file { '/var/www/analogi/db_ossec.php':
    mode    => '0644',
    content => template('ossec/db_ossec.php.erb'),
    owner   => root,
    group   => root,
    notify  => Service['apache2']
  }

  file { '/etc/apache2/sites-enabled/analogi':
    ensure  => file,
    mode    => '0644',
    source  => 'puppet:///modules/ossec/analogi',
    owner   => root,
    group   => root,
    notify  => Service['apache2'],
    require => [Package['php5'] , Package['php5-mysql']]
  }

  service{'apache2':
    ensure    => running,
    enable    => true,
    hasstatus => true,
    require   => [Package['apache2'],]
  }
}
