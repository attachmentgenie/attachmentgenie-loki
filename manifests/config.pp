# @summary A short summary of the purpose of this class
#
# https://grafana.com/docs/loki/next/configuration/
#
# @api private
class loki::config {
  $config_file = "${loki::config_dir}/${loki::config_file}"

  if $loki::manage_user {
    File[$loki::config_dir] {
      require => [Group['loki'],User['loki']],
    }
  }

  file { $loki::config_dir:
    ensure => directory,
    group  => $loki::group,
    owner  => $loki::user,
  }
  -> concat { $config_file:
    ensure => present,
    notify => $loki::service_notify,
  }

  concat::fragment { 'loki_config_header':
    target  => $config_file,
    content => "---\n",
    order   => '01',
  }

  # The module to run Loki with. Supported values
  # all, querier, query-scheduler, table-manager, ingester, distributor
  # [target: <string> | default = "all"]
  if $loki::target {
    concat::fragment { 'loki_config_target':
      target  => $config_file,
      content => "target: ${loki::target}\n",
      order   => '02',
    }
  }

  # Enables authentication through the X-Scope-OrgID header, which must be present
  # if true. If false, the OrgID will always be set to "fake".
  # [auth_enabled: <boolean> | default = true]
  concat::fragment { 'loki_config_auth_enabled':
    target  => $config_file,
    content => "auth_enabled: ${loki::auth_enabled}\n",
    order   => '03',
  }

  # Configure common settings section
  # [common: <common_config>]
  if $loki::common_config_hash {
    concat::fragment { 'loki_common_config':
      target  => $config_file,
      content => $loki::common_config_hash.stdlib::to_yaml.loki::strip_yaml_header,
      order   => '09',
    }
  }

  # Configures the server of the launched module(s).
  # [server: <server_config>]
  if $loki::server_config_hash {
    concat::fragment { 'loki_server_config':
      target  => $config_file,
      content => $loki::server_config_hash.stdlib::to_yaml.loki::strip_yaml_header,
      order   => '10',
    }
  }

  # Configures the distributor.
  # [distributor: <distributor_config>]
  if $loki::distributor_config_hash {
    concat::fragment { 'loki_distributor_config':
      target  => $config_file,
      content => $loki::distributor_config_hash.stdlib::to_yaml.loki::strip_yaml_header,
      order   => '11',
    }
  }

  # Configures the querier. Only appropriate when running all modules or
  # just the querier.
  # [querier: <querier_config>]
  if $loki::querier_config_hash {
    concat::fragment { 'loki_querier_config':
      target  => $config_file,
      content => $loki::querier_config_hash.stdlib::to_yaml.loki::strip_yaml_header,
      order   => '12',
    }
  }

  # The query_frontend_config configures the Loki query-frontend.
  # [frontend: <query_frontend_config>]
  if $loki::query_frontend_config_hash {
    concat::fragment { 'loki_query_frontend_config':
      target  => $config_file,
      content => $loki::query_frontend_config_hash.stdlib::to_yaml.loki::strip_yaml_header,
      order   => '13',
    }
  }

  # The queryrange_config configures the query splitting and caching in the Loki
  # query-frontend.
  # [query_range: <queryrange_config>]
  if $loki::query_range_config_hash {
    concat::fragment { 'loki_queryrange_config':
      target  => $config_file,
      content => $loki::query_range_config_hash.stdlib::to_yaml.loki::strip_yaml_header,
      order   => '14',
    }
  }

  # The ruler_config configures the Loki ruler.
  # [ruler: <ruler_config>]
  if $loki::ruler_config_hash {
    concat::fragment { 'loki_ruler_config':
      target  => $config_file,
      content => $loki::ruler_config_hash.stdlib::to_yaml.loki::strip_yaml_header,
      order   => '15',
    }
  }

  # Configures how the distributor will connect to ingesters. Only appropriate
  # when running all modules, the distributor, or the querier.
  # [ingester_client: <ingester_client_config>]
  if $loki::ingester_client_config_hash {
    concat::fragment { 'loki_ingester_client_config':
      target  => $config_file,
      content => $loki::ingester_client_config_hash.stdlib::to_yaml.loki::strip_yaml_header,
      order   => '16',
    }
  }

  # Configures the ingester and how the ingester will register itself to a
  # key value store.
  # [ingester: <ingester_config>]
  if $loki::ingester_config_hash {
    concat::fragment { 'loki_ingester_config':
      target  => $config_file,
      content => $loki::ingester_config_hash.stdlib::to_yaml.loki::strip_yaml_header,
      order   => '17',
    }
  }

  # Configures where Loki will store data.
  # [storage_config: <storage_config>]
  concat::fragment { 'loki_storage_config':
    target  => $config_file,
    content => $loki::storage_config_hash.stdlib::to_yaml.loki::strip_yaml_header,
    order   => '18',
  }

  # Configures how Loki will store data in the specific store.
  # [chunk_store_config: <chunk_store_config>]
  if $loki::chunk_store_config_hash {
    concat::fragment { 'loki_chunk_store_config':
      target  => $config_file,
      content => $loki::chunk_store_config_hash.stdlib::to_yaml.loki::strip_yaml_header,
      order   => '19',
    }
  }

  # Configures the chunk index schema and where it is stored.
  # [schema_config: <schema_config>]
  concat::fragment { 'loki_schema_config':
    target  => $config_file,
    content => $loki::schema_config_hash.stdlib::to_yaml.loki::strip_yaml_header,
    order   => '20',
  }

  # Configures limits per-tenant or globally
  # [limits_config: <limits_config>]
  if $loki::limits_config_hash {
    concat::fragment { 'loki_limits_config':
      target  => $config_file,
      content => $loki::limits_config_hash.stdlib::to_yaml.loki::strip_yaml_header,
      order   => '21',
    }
  }

  # Configures the compactor component which compacts index shards for performance.
  # [compactor: <compactor_config>]
  if $loki::compactor_config_hash {
    concat::fragment { 'loki_compactor_config':
      target  => $config_file,
      content => $loki::compactor_config_hash.stdlib::to_yaml.loki::strip_yaml_header,
      order   => '22',
    }
  }

  # The frontend_worker_config configures the worker - running within the Loki
  # querier - picking up and executing queries enqueued by the query-frontend.
  # [frontend_worker: <frontend_worker_config>]
  if $loki::frontend_worker_config_hash {
    concat::fragment { 'loki_frontend_worker_config':
      target  => $config_file,
      content => $loki::frontend_worker_config_hash.stdlib::to_yaml.loki::strip_yaml_header,
      order   => '23',
    }
  }

  # Configures the table manager for retention
  # [table_manager: <table_manager_config>]
  if $loki::table_manager_config_hash {
    concat::fragment { 'loki_table_manager_config':
      target  => $config_file,
      content => $loki::table_manager_config_hash.stdlib::to_yaml.loki::strip_yaml_header,
      order   => '24',
    }
  }

  # Configuration for "runtime config" module, responsible for reloading runtime configuration file.
  # [runtime_config: <runtime_config>]
  if $loki::runtime_config_hash {
    concat::fragment { 'loki_runtime_config':
      target  => $config_file,
      content => $loki::runtime_config_hash.stdlib::to_yaml.loki::strip_yaml_header,
      order   => '25',
    }
  }

  # Configuration for tracing
  # [tracing: <tracing_config>]
  if $loki::tracing_config_hash {
    concat::fragment { 'loki_tracing_config':
      target  => $config_file,
      content => $loki::tracing_config_hash.stdlib::to_yaml.loki::strip_yaml_header,
      order   => '26',
    }
  }

  # Configuration for memberlist
  # [memberlist: <memberlist_config>]
  if $loki::memberlist_config_hash {
    concat::fragment { 'loki_memberlist_config':
      target  => $config_file,
      content => $loki::memberlist_config_hash.stdlib::to_yaml.loki::strip_yaml_header,
      order   => '27',
    }
  }

  # Configures the query_scheduler. Only appropriate when running all modules or
  # just the query-scheduler.
  # [query_scheduler: <query_scheduler_config>]
  if $loki::query_scheduler_config_hash {
    concat::fragment { 'loki_query_scheduler_config':
      target  => $config_file,
      content => $loki::query_scheduler_config_hash.stdlib::to_yaml.loki::strip_yaml_header,
      order   => '28',
    }
  }
}
