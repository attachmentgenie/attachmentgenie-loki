# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include loki
class loki (
  Stdlib::Absolutepath $bin_dir,
  Stdlib::Absolutepath $config_dir,
  Stdlib::Absolutepath $data_dir,
  String[1] $group,
  Enum['archive','package'] $install_method,
  Boolean $manage_service,
  Boolean $manage_user = $install_method ? { 'archive' => true, 'package' => false },
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
  Optional[Hash] $querier_config_hash = undef,
  Optional[Hash] $query_frontend_config_hash = undef,
  Optional[Hash] $queryrange_config_hash = undef,
  Optional[Hash] $ruler_config_hash = undef,
  Optional[Hash] $runtime_config_hash = undef,
  Optional[Hash] $server_config_hash = undef,
  Optional[Hash] $table_manager_config_hash = undef,
  Optional[Enum['all', 'querier', 'table-manager', 'ingester', 'distributor']] $target = undef,
  Optional[Hash] $tracing_config_hash = undef,
) {
  anchor { 'loki::begin': }
-> class{ '::loki::install': }
-> class{ '::loki::config': }
~> class{ '::loki::service': }
-> anchor { 'loki::end': }
}
