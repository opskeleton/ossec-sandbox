# ossec setup
class ossec {
  class{'apt':
    always_apt_update => true
  }

  Exec['apt_update'] -> Package <||>
}
