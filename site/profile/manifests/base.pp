class profile::base {

  #the base profile should include component modules that will be on all nodes
  file {'/tmp/base.txt':
    ensure  => present,
    content => 'hello from base',
  }
}
