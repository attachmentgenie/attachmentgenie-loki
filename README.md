# attachmentgenie-loki

[![](https://img.shields.io/puppetforge/pdk-version/attachmentgenie/loki.svg?style=popout)](https://forge.puppetlabs.com/attachmentgenie/loki)
[![](https://img.shields.io/puppetforge/v/attachmentgenie/loki.svg?style=popout)](https://forge.puppetlabs.com/attachmentgenie/loki)
[![](https://img.shields.io/puppetforge/dt/attachmentgenie/loki.svg?style=popout)](https://forge.puppetlabs.com/attachmentgenie/loki)
[![Spec Tests](https://github.com/attachmentgenie/attachmentgenie-loki/actions/workflows/spec.yml/badge.svg)](https://github.com/attachmentgenie/attachmentgenie-loki/actions/workflows/spec.yml)
[![License](https://img.shields.io/github/license/attachmentgenie/attachmentgenie-loki?stype=popout)](https://github.com/attachmentgenie/attachmentgenie-loki/blob/master/LICENSE)

Deploy and configure loki on a node.

- [Description](#description)
- [Usage](#usage)
- [Reference](#reference)
- [Changelog](#changelog)
- [Limitations](#limitations)
- [Development](#development)

## Description

[Loki](https://grafana.com/oss/loki)

It primarily:

1. Discovers targets
2. Attaches labels to log streams
3. Pushes them to the Loki instance.

Currently, Loki can tail logs from two sources: local log files and the systemd journal (on AMD64 machines only).

## Usage

All options and configuration can be done through interacting with the parameters
on the main loki class.
These are now documented via [Puppet Strings](https://github.com/puppetlabs/puppet-strings)

You can view example usage in [REFERENCE](REFERENCE.md).

```
## Reference

See [REFERENCE](REFERENCE.md).

## Limitations

This is where you list OS compatibility, version compatibility, etc.

## Development

### Running tests

This project contains tests for both rspec-puppet and litmus to verify functionality. For detailed information on using these tools, please see their respective documentation.

#### Testing quickstart:

```
pdk bundle install
pdk bundle exec rake 'litmus:provision_list[puppet6]'
pdk bundle exec rake 'litmus:install_agent[puppet6]'
pdk bundle exec rake litmus:install_module
pdk bundle exec rake litmus:acceptance:parallel
pdk bundle exec rake litmus:tear_down
