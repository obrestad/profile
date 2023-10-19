# Configures the puppetmaster
class profile::puppet::server::config {
  $report_url = lookup('profile::puppet::report::url', {
    'default_value' => false,
    'value_type'    => Variant[String, Boolean],
  })
  $puppetca = lookup('profile::puppet::caserver', Stdlib::Fqdn)

  $puppetdb = lookup('profile::puppet::db::server', {
    'default_value' => false,
    'value_type'    => Variant[Stdlib::Fqdn, Boolean],
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
    }

    ini_setting { 'Puppet Report url':
      ensure  => present,
      path    => '/etc/puppetlabs/puppet/puppet.conf',
      section => 'master',
      setting => 'reports',
      value   => $report_url,
    }
  } else {
    ini_setting { 'Puppet Report type':
      ensure  => absent,
      path    => '/etc/puppetlabs/puppet/puppet.conf',
      section => 'master',
      setting => 'reports',
    }

    ini_setting { 'Puppet Report url':
      ensure  => absent,
      path    => '/etc/puppetlabs/puppet/puppet.conf',
      section => 'master',
      setting => 'reports',
    }
  }

}
