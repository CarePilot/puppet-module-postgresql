class postgresql::server($version="9.0",
                         $listen_addresses='*',
                         $max_connections=100,
                         $use_ssl=false,
                         $durable=true) {

  $postgresql = $operatingsystem ? {
    /(?i)(ubuntu|debian)/ => "postgresql-${version}",
    default               => undef,
  }

  package { 'rsyslog-pgsql':
    ensure => present,
  }
  package { $postgresql:
    ensure => present,
    require=> File['/etc/apt/preferences.d/postgresql'],
  }

  file { '/etc/apt/preferences.d/postgresql':
    ensure => present,
    source => "puppet:///modules/postgresql/preferences/postgresql",
  }

  file { 'shmmax.conf':
    path => '/etc/sysctl.d/shmmax.conf',
    source => 'puppet:///modules/postgresql/sysctl/shmmax.conf',
  }
  file { 'shmall.conf':
    path => '/etc/sysctl.d/shmall.conf',
    source => 'puppet:///modules/postgresql/sysctl/shmall.conf',
  }

  file { "pg_hba.conf":
    path => "/etc/postgresql/${version}/main/pg_hba.conf",
    source => "puppet:///modules/postgresql/pg_hba.conf",
    mode => 640,
    require => Package[$postgresql],
  }

  file { '/etc/postgresql':                 ensure => directory }
  file { '/etc/postgresql/${version}':      ensure => directory, require => File['/etc/postgresql'], }
  file { '/etc/postgresql/${version}/main': ensure => directory, require => File['/etc/postgresql/${version}'] }
  file { "postgresql.conf":
    path    => "/etc/postgresql/${version}/main/postgresql.conf",
    content => template("postgresql/postgresql.conf.erb"),
    require => [ Package[$postgresql],
                 File['/etc/postgresql/${version}/main'], ],
  }

  service { postgresql:
    ensure => running,
    enable => true,
    hasstatus => true,
    hasrestart => true,
    require => [ File['shmmax.conf'], File['shmall.conf'],
                 Package['rsyslog-pgsql'] ],
    subscribe => [Package[$postgresql],
                  File["pg_hba.conf"],
                  File["postgresql.conf"]],
  }
}
