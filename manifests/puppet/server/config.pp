# Configures the puppetmaster
class profile::puppet::server::config {
  $report_url = lookup('profile::puppet::report::url', {
    'default_value' => false,
    'value_type'    => Variant[String, Boolean],
  })
  $puppetca = lookup('profile::puppet::caserver', Stdlib::Fqdn)

  $puppetdb = lookup('profile::puppet::db::server', {
    'default_value' => undef,
    'value_type'    => Optional[Stdlib::Fqdn],
  })

  include ::profile::puppet::altnames
  include ::shiftleader::integration::puppet

  if($puppetca == $::fqdn) {
    $template = 'ca.enabled.cfg'

    file { '/etc/puppetlabs/puppetserver/conf.d/ca.conf':
      ensure  => present,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      source  => 'puppet:///modules/profile/puppet/ca.conf',
      notify  => Service['puppetserver'],
      require => Package['puppetserver'],
    }

  } else {
    $template = 'ca.disabled.cfg'

    file { '/etc/puppetlabs/puppet/ssl/ca/ca_crl.pem':
      ensure  => 'link',
      owner   => 'puppet',
      group   => 'puppet',
      target  => '/etc/puppetlabs/puppet/ssl/crl.pem',
      replace => false,
      notify  => Service['puppetserver'],
      require => File['/etc/puppetlabs/puppet/ssl/ca'],
    }

    file { '/etc/puppetlabs/puppet/ssl/ca':
      ensure  => 'directory',
      mode    => '0755',
      owner   => 'puppet',
      group   => 'puppet',
      require => Package['puppetserver'],
    }
  }

  if($puppetdb) {
    package { 'puppetdb-termini':
      ensure => present,
    }

    ini_setting { 'Puppetdb url':
      ensure  => present,
      path    => '/etc/puppetlabs/puppet/puppetdb.conf',
      section => 'main',
      setting => 'server_urls',
      value   => "https://${puppetdb}:8081/",
      require => Package['puppetdb-termini'],
      notify  => Service['puppetserver'],
    }

    ini_setting { 'Puppet storeconfigs':
      ensure  => present,
      path    => '/etc/puppetlabs/puppet/puppet.conf',
      section => 'master',
      setting => 'storeconfigs',
      value   => 'true',
      notify  => Service['puppetserver'],
      require => Package['puppetserver'],
    }

    ini_setting { 'Puppet storeconfigs backend':
      ensure  => present,
      path    => '/etc/puppetlabs/puppet/puppet.conf',
      section => 'master',
      setting => 'storeconfigs_backend',
      value   => 'puppetdb',
      notify  => Service['puppetserver'],
      require => Package['puppetserver'],
    }
  } else {
    ini_setting { 'Puppet storeconfigs':
      ensure  => absent,
      path    => '/etc/puppetlabs/puppet/puppet.conf',
      section => 'master',
      setting => 'storeconfigs',
      notify  => Service['puppetserver'],
      require => Package['puppetserver'],
    }

    ini_setting { 'Puppet storeconfigs backend':
      ensure  => absent,
      path    => '/etc/puppetlabs/puppet/puppet.conf',
      section => 'master',
      setting => 'storeconfigs_backend',
      notify  => Service['puppetserver'],
      require => Package['puppetserver'],
    }
  }

  file { '/etc/puppetlabs/puppetserver/services.d/ca.cfg':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    source  => "puppet:///modules/profile/puppet/${template}",
    notify  => Service['puppetserver'],
    require => Package['puppetserver'],
  }

  if($report_url) {
    ini_setting { 'Puppet Report type':
      ensure  => present,
      path    => '/etc/puppetlabs/puppet/puppet.conf',
      section => 'master',
      setting => 'reports',
      value   => 'http',
      notify  => Service['puppetserver'],
      require => Package['puppetserver'],
    }

    ini_setting { 'Puppet Report url':
      ensure  => present,
      path    => '/etc/puppetlabs/puppet/puppet.conf',
      section => 'master',
      setting => 'reporturl',
      value   => $report_url,
      notify  => Service['puppetserver'],
      require => Package['puppetserver'],
    }
  } else {
    ini_setting { 'Puppet Report type':
      ensure  => absent,
      path    => '/etc/puppetlabs/puppet/puppet.conf',
      section => 'master',
      setting => 'reports',
      notify  => Service['puppetserver'],
      require => Package['puppetserver'],
    }

    ini_setting { 'Puppet Report url':
      ensure  => absent,
      path    => '/etc/puppetlabs/puppet/puppet.conf',
      section => 'master',
      setting => 'reporturl',
      notify  => Service['puppetserver'],
      require => Package['puppetserver'],
    }
  }

}
