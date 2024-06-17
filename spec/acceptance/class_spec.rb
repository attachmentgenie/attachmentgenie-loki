# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'with default parameters ', if: ['debian', 'redhat', 'ubuntu'].include?(os[:family]) do
  pp = <<-PUPPETCODE
  package { 'unzip':
    ensure => present,
  }
  -> class{ 'loki':
    auth_enabled                => false,
    common_config_hash          => {'common' => {'path_prefix' => '/var/lib/loki',}},
    schema_config_hash          => {'schema_config' => {'configs' => [{'from' => '2020-05-15', 'store' => 'boltdb', 'object_store' => 'filesystem', 'schema' => 'v11', 'index' =>{'prefix' => 'index_', 'period' => '168h'}}]}},
    storage_config_hash         => {'storage_config' => { 'boltdb' => { 'directory' => '/var/lib/loki/index',}, 'filesystem' => {'directory' => '/var/lib/loki/chunks',},},},
    server_config_hash          => {'server' => {'http_listen_port' => 3100, 'http_listen_address' => $facts['networking']['ip']},},
    ingester_client_config_hash => {'ingester' => { 'lifecycler' => {'interface_names' => [$facts['networking']['primary']], 'address' => '127.0.0.1', 'ring' =>{'kvstore' =>{'store' => 'inmemory'}, 'replication_factor' => 1}}}},
  }
PUPPETCODE

  it 'applies idempotently' do
    idempotent_apply(pp)
  end

  describe group('loki') do
    it { is_expected.to exist }
  end

  describe user('loki') do
    it { is_expected.to exist }
  end

  describe file('/etc/loki') do
    it { is_expected.to be_directory }
  end

  describe file('/var/lib/loki') do
    it { is_expected.to be_directory }
  end

  describe service('loki') do
    it { is_expected.to be_enabled }
    it { is_expected.to be_running.under('systemd') }
  end

  describe port(3100) do
    it { is_expected.to be_listening }
  end
end
