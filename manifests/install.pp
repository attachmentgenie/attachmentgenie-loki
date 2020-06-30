# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include loki::install
class loki::install {
  case $::loki::install_method {
    'archive': {
      $release_file_name = 'loki-linux-amd64'
      $release_file_name_logcli = 'logcli-linux-amd64'

      $version_dir = "${loki::data_dir}/loki-${loki::version}"

      $binary_path = "${version_dir}/${release_file_name}"
      $binary_path_logcli = "${version_dir}/${release_file_name_logcli}"

      if $::loki::manage_user {
        user { 'loki':
          ensure => present,
          home   => $loki::data_dir,
          name   => $::loki::user,
        }
        group { 'loki':
          ensure => present,
          name   => $::loki::group
        }

        File[$version_dir] {
          require => [Group['loki'],User['loki']],
        }
      }

      file { [$loki::data_dir, $version_dir]:
        ensure => directory,
        group  => $::loki::group,
        owner  => $::loki::user,
      }
      -> archive { "${binary_path}.zip":
        ensure       => present,
        source       => "https://github.com/grafana/loki/releases/download/${loki::version}/${release_file_name}.zip",
        extract      => true,
        extract_path => $version_dir,
        creates      => $binary_path,
        cleanup      => false,
        user         => $::loki::user,
        group        => $::loki::group,
      }
      -> archive { "${binary_path_logcli}.zip":
        ensure       => present,
        source       => "https://github.com/grafana/loki/releases/download/${loki::version}/${release_file_name_logcli}.zip",
        extract      => true,
        extract_path => $version_dir,
        creates      => $binary_path_logcli,
        cleanup      => false,
        user         => $::loki::user,
        group        => $::loki::group,
      }

      file {
        $binary_path:
          ensure  => file,
          mode    => '0755',
          require => Archive["${binary_path}.zip"],
        ;
        "${loki::bin_dir}/loki":
          ensure  => link,
          target  => $binary_path,
          require => File[$binary_path],
          notify  => Service['loki'],
        ;
      }

      file {
        $binary_path_logcli:
          ensure  => file,
          mode    => '0755',
          require => Archive["${binary_path_logcli}.zip"],
        ;
        "${loki::bin_dir}/logcli":
          ensure  => link,
          target  => $binary_path_logcli,
          require => File[$binary_path_logcli],
          notify  => Service['loki'],
        ;
      }
    }
    'package': {
      package { 'loki':
        ensure => $::loki::package_version,
        name   => $::loki::package_name,
      }
    }
    default: {
      fail("Installation method ${::loki::install_method} not supported")
    }
  }
}
