group{ 'puppet': ensure  => present }

node 'ossec-server.local' {
  include ossec
  include ossec::server
}

node 'ossec-agent.local' {
  include ossec
  include ossec::agent
}
