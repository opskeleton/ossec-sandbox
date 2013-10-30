# ossec setup
class ossec {
  class{'apt':
    always_apt_update => true
  }

  Exec['apt_update'] -> Package <||>

  file_line { 'inotify.max_user_watches':
    path => '/etc/sysctl.conf',
    line => 'fs.inotify.max_user_watches=100000'
  }
}
