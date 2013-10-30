# ossec server setup
# see http://nolabnoparty.com/en/setup-ossec-with-mysql-and-analogi-in-centos-6/
class ossec::server($dbuser='', $dbpass='',$dbhost='') {

  class{'ossec::analogi':
    dbuser => $dbuser,
    dbpass => $dbpass,
    dbhost => $dbhost
  }

  package{'ossec-hids-server':
    ensure   => present,
    provider => dpkg,
    source   => '/vagrant/ossec-hids-server_2.7.0-ubuntu12_amd64.deb',
    notify   => Exec['enable_database']
  }


  class{'mysql::server':
  } ->

  mysql::db { 'ossec':
    user     => $dbuser,
    password => $dbpass,
    host     => 'localhost',
    grant    => ['SELECT', 'UPDATE', 'INSERT', 'CREATE', 'DELETE', 'EXECUTE'],
  }

  exec{'setup-schema':
    command     => 'mysql -u root -D ossec < /tmp/mysql.schema',
    user        => 'root',
    path        => '/usr/bin',
    unless      => "/usr/bin/mysql -u root -D ossec -e 'select * from category'",
    require     => [File['/tmp/mysql.schema'], Mysql::Db['ossec']]
  }

  file { '/tmp/mysql.schema':
    ensure=> file,
    mode  => '0644',
    source=> 'puppet:///modules/ossec/mysql.schema',
    owner => root,
    group => root,
  }

  exec{'enable_database':
    command     => '/var/ossec/bin/ossec-control enable database',
    user        => 'root',
    refreshonly => true,
    require     => [Package['ossec-hids-server'], Exec['setup-schema'],
                    File['/var/ossec/etc/ossec.conf']]
  }

  file { '/var/ossec/etc/ossec.conf':
    ensure  => file,
    mode    => '0440',
    content => template('ossec/ossec.conf.erb'),
    owner   => ossec,
    group   => ossec,
    require => Package['ossec-hids-server']
  } ~>

  service{'ossec-hids-server':
    ensure    => running,
    enable    => true,
    hasstatus => true,
    require   => Exec['setup-schema']
  }

}
