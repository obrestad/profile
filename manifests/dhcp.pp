# Installs and configures a DHCP server
class profile::dhcp {
  $searchdomains = lookup('profile::dhcp::searchdomains', Array[Stdlib::Fqdn])
  $ntp_servers = lookup('profile::ntp::servers', {
    'value_type' => Array[Variant[Stdlib::Fqdn, Stdlib::IP::Address]],
    'merge'      => 'unique',
  })
  $dhcp_interfaces = lookup('profile::dhcp::interfaces', {
    'value_type'    => Array[String],
  })

  $networks = lookup('profile::networks', {
    'default_value' => {},
    'value_type'    => Hash,
  })

  $omapi_name = lookup('profile::dhcp::omapi::name', String)
  $omapi_key = lookup('profile::dhcp::omapi::key', String)
  $omapi_algorithm = lookup('profile::dhcp::omapi::algorithm', {
    'default_value' => 'HMAC-MD5',
    'value_type'    => String,
  })
  $omapi_port = lookup('profile::dhcp::omapi::port', {
    'value_type'    => Stdlib::Port,
    'default_value' => 7911,
  })

  $tftp_server = lookup('profile::tftp::server', {
    'value_type'    => Stdlib::IP::Address::V4,
  })
  $pxe_file = lookup('profile::dhcp::pxe::file', {
    'value_type'    => String,
    'default_value' => 'pxelinux.0',
  })
  $uefi_file = lookup('profile::dhcp::uefi::file', {
    'value_type'    => String,
    'default_value' => 'syslinux.efi',
  })

  $nameservers = lookup('profile::dns::resolvers', {
    'value_type' => Array[Stdlib::IP::Address::V4],
    'merge'      => 'unique',
  })

  $pxe_logic = {
    uefi1 => {
      parameters => [
        'match if substring(option vendor-class-identifier, 0, 20) = "PXEClient:Arch:00007"',
        "next-server ${tftp_server}",
        "filename \"${uefi_file}\""
      ],
    },
    uefi2 => {
      parameters => [
        'match if substring(option vendor-class-identifier, 0, 20) = "PXEClient:Arch:00008"',
        "next-server ${tftp_server}",
        "filename \"${uefi_file}\""
      ],
    },
    uefi3 => {
      parameters => [
        'match if substring(option vendor-class-identifier, 0, 20) = "PXEClient:Arch:00009"',
        "next-server ${tftp_server}",
        "filename \"${uefi_file}\""
      ],
    },
    bios => {
      parameters => [
        'match if substring(option vendor-class-identifier, 0, 20) = "PXEClient:Arch:00000"',
        "next-server ${tftp_server}",
        "filename \"${pxe_file}\""
      ]
    }
  }

  include ::profile::dhcp::firewall

  class { '::dhcp':
    dnssearchdomains => $searchdomains,
    interfaces       => $dhcp_interfaces,
    nameservers      => $nameservers,
    ntpservers       => $ntp_servers,
    omapi_algorithm  => $omapi_algorithm,
    omapi_key        => $omapi_key,
    omapi_name       => $omapi_name,
    omapi_port       => $omapi_port,
    dhcp_classes     => $pxe_logic,
  }

  $networks.each | $name, $data | {
    if('ipv4' in $data and 'id' in $data['ipv4'] and 'mask' in $data['ipv4']) {
      ::dhcp::pool { $name:
        network     => $data['ipv4']['id'],
        mask        => $data['ipv4']['mask'],
        gateway     => 'gateway' in $data['ipv4'] = {
          true  => $data['ipv4']['gateway'],
          false => undef,
        },
        domain_name => 'domain' in $data = {
          true  => $data['domain'],
          false => undef,
        },
      }
    } else {
      notify { "unconfigured ${name}":
        message  => "Skipped DHCP-pool for ${name} due to missing parameters",
        withpath => true,
      }
    }
  }
}
