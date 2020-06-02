# frozen_string_literal: true

require 'spec_helper'

describe 'loki::config' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:pre_condition) do
        "class { 'loki':
          schema_config_hash  => { 'schema_config' => {}},
          storage_config_hash => { 'storage_config' => {}},
        }"
      end

      it { is_expected.to compile }
    end
  end
end
