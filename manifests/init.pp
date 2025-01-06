# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example Minimal example, creates a standalone loki instance (not desinged for production).
#     class{ 'loki':
#       auth_enabled                => false,
#       common_config_hash          => {'common' => {
#                                         'path_prefix' => '/var/lib/loki',
#                                      }},
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
#
# @param bin_dir path to install binary file.
# @param config_dir path to install configuration file.
# @param config_file file to install configuration in.
# @param data_dir path where loki data will be stored.
# @param group Group that owns loki files.
# @param install_method How to install loki.
# @param manage_service Manage the loki service.
# @param package_name Name of package to install.
# @param package_version Version of package to install.
# @param schema_config_hash Configures the chunk index schema
# @param service_name Name of service to manage.
# @param service_provider Init system that is used.
# @param service_ensure The state of the service.
# @param storage_config_hash The storage_config block configures one of many possible stores for both the index and chunks.
# @param user User that owns example files.
# @param version Version to install.
# @param auth_enabled Enables authentication
# @param chunk_store_config_hash The chunk_store_config block configures how chunks will be cached
# @param compactor_config_hash Configures the compactor component which compacts index shards for performance.
# @param distributor_config_hash Configures the distributor.
# @param frontend_worker_config_hash The frontend_worker_config configures the worker
# @param ingester_client_config_hash Configures how the distributor will connect to ingesters.
# @param ingester_config_hash The ingester_client block configures how the distributor will connect to ingesters.
# @param limits_config_hash The limits_config block configures global and per-tenant limits in Loki.
# @param manage_user Manage loki user and group.
# @param manage_unit_file Manage unit file for service
# @param querier_config_hash Configures the querier.
# @param query_scheduler_config_hash The query_scheduler block configures the Loki query scheduler.
# @param query_frontend_config_hash The query_frontend block configures the Loki query address.
# @param query_range_config_hash The query_range block configures the query splitting and caching in the Loki query-frontend.
# @param ruler_config_hash The ruler block configures the Loki ruler.
# @param runtime_config_hash Configuration for 'runtime config' module, responsible for reloading runtime configuration file.
# @param server_config_hash Configures the server of the launched module(s).
# @param table_manager_config_hash The table_manager block configures the table manager for retention.
# @param target A comma-separated list of components to run.
# @param tracing_config_hash Configuration for tracing.,
# @param memberlist_config_hash Configuration for memberlist client. Only applies if the selected kvstore is memberlist
# @param common_config_hash Common configuration to be shared between multiple modules.
# @param pattern_ingester_config_hash The pattern_ingester block configures the pattern ingester.
class loki (
  Stdlib::Absolutepath $bin_dir,
  Stdlib::Absolutepath $config_dir,
  String[1] $config_file,
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
  Boolean $auth_enabled = true,
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
  Optional[Hash] $query_range_config_hash = undef,
  Optional[Hash] $ruler_config_hash = undef,
  Optional[Hash] $runtime_config_hash = undef,
  Optional[Hash] $server_config_hash = undef,
  Optional[Hash] $table_manager_config_hash = undef,
  Optional[Loki::Target] $target = undef,
  Optional[Hash] $tracing_config_hash = undef,
  Optional[Hash] $memberlist_config_hash = undef,
  Optional[Hash] $common_config_hash = undef,
  Optional[Hash] $pattern_ingester_config_hash = undef,
) {
  if $loki::manage_service {
    $service_notify = [Service['loki']]
  } else {
    $service_notify = []
  }

  contain loki::install
  contain loki::config
  contain loki::service

  Class['loki::install']
  -> Class['loki::config']
  ~> Class['loki::service']
}
