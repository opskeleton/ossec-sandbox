# ossec server setup
# see http://nolabnoparty.com/en/setup-ossec-with-mysql-and-analogi-in-centos-6/
class ossec::server($dbpass='',$dbuser='',$mysql_root='') {

  package{'ossec-hids-server':
    ensure   => present,
    provider => dpkg,
    source   => '/vagrant/ossec-hids-server_2.7.0-ubuntu12_amd64.deb'
  }

  # package{['libmysql++-dev','build-essential']:
  #   ensure  => present
  # }

  # package{"linux-headers-${::kernelrelease}":
  #   ensure  => present
  # }

  Exec['apt_update'] -> Package <||>

  class{'mysql::server':
    # root_password => $mysql_root
  } ->

  mysql::db { 'ossec':
    user     => $dbuser,
    password => $dbpass,
    host     => 'localhost',
    grant    => ['SELECT', 'UPDATE', 'INSERT', 'CREATE', 'DELETE', 'EXECUTE'],
  } ~>

  exec{'setyp-schema':
    command     => 'mysql -u root -D ossec < /tmp/mysql.schema',
    user        => 'root',
    path        => ['/usr/bin','/bin'],
    refreshonly => true,
    require     => File['/tmp/mysql.schema']
  }

  file { '/tmp/mysql.schema':
    ensure=> file,
    mode  => '0644',
    source=> 'puppet:///modules/ossec/mysql.schema',
    owner => root,
    group => root,
  }

}
