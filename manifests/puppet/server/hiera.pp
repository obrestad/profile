# Sets up a hiera
class profile::puppet::server::hiera {
  file { '/etc/puppetlabs/puppet/hiera.yaml':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    source  => 'puppet:///modules/profile/puppet/hiera.yaml',
    notify  => Service['puppetserver'],
    require => Package['puppetserver'],
  }

  file { '/etc/puppetlabs/puppet/data':
    ensure => 'directory',
    mode   => '0755',
    owner  => 'root',
    group  => 'root',
  }

  file { '/root/hieradata':
    ensure => link,
    target => '/etc/puppetlabs/puppet/data',
    owner  => 'root',
    group  => 'root',
  }
}
