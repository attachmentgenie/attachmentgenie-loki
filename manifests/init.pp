# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example Minimal example, creates a standalone loki instance (not desinged for production).
#     class{ 'loki':
#       auth_enabled                => false,
#       schema_config_hash          => {'schema_config' => {
#                                         'configs' => [{
#                                           'from'         => '2020-05-15',
#                                           'store'        => 'boltdb',
#                                           'object_store' => 'filesystem',
#                                           'schema'       => 'v11',
#                                           'index'        => {'prefix' => 'index_', 'period' => '168h'},
#                                         }]
#                                      }},
#       storage_config_hash         => {'storage_config' => {
#                                         'boltdb'     => { 'directory' => '/var/lib/loki/index'},
#                                         'filesystem' => {'directory' => '/var/lib/loki/chunks'},
#                                      }},
#       server_config_hash          => {'server' => {
#                                         'http_listen_port'    => 3100,
#                                         'http_listen_address' => $facts['networking']['ip']},
#                                      },
#       ingester_client_config_hash => {'ingester' => {
#                                         'lifecycler' => {
#                                             'interface_names' => [$facts['networking']['primary']],
#                                             'address'         => '127.0.0.1',
#                                             'ring'            => {'kvstore' =>{'store' => 'inmemory'}, 'replication_factor' => 1},
#                                         }
#                                      }},
#     }
class loki (
  Stdlib::Absolutepath $bin_dir,
  Stdlib::Absolutepath $config_dir,
  Stdlib::Absolutepath $data_dir,
  String[1] $group,
  Enum['archive','package'] $install_method,
  Boolean $manage_service,
  String[1] $package_name,
  String[1] $package_version,
  Hash $schema_config_hash,
  String[1] $service_name,
  Enum['systemd'] $service_provider,
  Enum['running','stopped'] $service_ensure,
  Hash $storage_config_hash,
  String[1] $user,
  String[1] $version,
  Optional[Boolean] $auth_enabled = undef,
  Optional[Hash] $chunk_store_config_hash = undef,
  Optional[Hash] $compactor_config_hash = undef,
  Optional[Hash] $distributor_config_hash = undef,
  Optional[Hash] $frontend_worker_config_hash = undef,
  Optional[Hash] $ingester_client_config_hash = undef,
  Optional[Hash] $ingester_config_hash = undef,
  Optional[Hash] $limits_config_hash = undef,
  Boolean $manage_user = $install_method ? { 'archive' => true, 'package' => false },
  Boolean $manage_unit_file = $install_method ? { 'archive' => true, 'package' => false },
  Optional[Hash] $querier_config_hash = undef,
  Optional[Hash] $query_scheduler_config_hash = undef,
  Optional[Hash] $query_frontend_config_hash = undef,
  Optional[Hash] $queryrange_config_hash = undef,
  Optional[Hash] $ruler_config_hash = undef,
  Optional[Hash] $runtime_config_hash = undef,
  Optional[Hash] $server_config_hash = undef,
  Optional[Hash] $table_manager_config_hash = undef,
  Optional[Enum['all', 'querier', 'query-scheduler', 'table-manager', 'ingester', 'distributor']] $target = undef,
  Optional[Hash] $tracing_config_hash = undef,
  Optional[Hash] $memberlist_config_hash = undef,
) {
  anchor { 'loki::begin': }
-> class{ '::loki::install': }
-> class{ '::loki::config': }
~> class{ '::loki::service': }
-> anchor { 'loki::end': }
}
