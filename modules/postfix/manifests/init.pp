class postfix {
  package { [ 'postfix', 'mailutils' ]: ensure => present, }
  service { 'postfix':
    ensure     => running,
    hasstatus  => true,
    hasrestart => true,
    enable     => true,
  }
}
