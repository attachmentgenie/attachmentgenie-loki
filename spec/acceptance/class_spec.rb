# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'with default parameters ', if: ['debian', 'redhat', 'ubuntu'].include?(os[:family]) do
  pp = <<-PUPPETCODE
  class { '::loki': }
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
    it { is_expected.to be_file }
  end

  describe service('loki') do
    it { is_expected.to be_enabled }
    it { is_expected.to be_running.under('systemd') }
  end

  describe port(3100) do
    it { is_expected.to be_listening }
  end
end
