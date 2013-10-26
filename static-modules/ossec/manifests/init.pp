# ossec setup
class ossec {
  include apt

  apt::source { 'ossec-ubuntu':
    location          => 'http://ppa.launchpad.net/nicolas-zin/ossec-ubuntu/ubuntu',
    release           => 'precise',
    repos             => 'main',
    key               => '0C4FF926',
    key_server        => 'keyserver.ubuntu.com',
  }

}
