# @summary A short summary of the purpose of this class
#
# @api private
class loki::service {
  if $::loki::manage_service {
    case $::loki::service_provider {
      'systemd': {
        if $::loki::manage_unit_file {
          ::systemd::unit_file { "${::loki::service_name}.service":
            content => epp('loki/loki.service.epp'),
            before  => Service['loki'],
          }
        }
      }
      default: {
        fail("Service provider ${::loki::service_provider} not supported")
      }
    }

    case $::loki::install_method {
      'archive': {}
      'package': {
        Service['loki'] {
          subscribe => Package['loki'],
        }
      }
      default: {
        fail("Installation method ${::loki::install_method} not supported")
      }
    }

    service { 'loki':
      ensure   => $::loki::service_ensure,
      enable   => true,
      name     => $::loki::service_name,
      provider => $::loki::service_provider,
    }
  }
}
