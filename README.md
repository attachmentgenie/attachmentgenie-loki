# Loki

![](https://img.shields.io/puppetforge/pdk-version/attachmentgenie/loki.svg?style=popout)
![](https://img.shields.io/puppetforge/v/attachmentgenie/loki.svg?style=popout)
![](https://img.shields.io/puppetforge/dt/attachmentgenie/loki.svg?style=popout)
![](https://travis-ci.org/attachmentgenie/attachmentgenie-loki.svg?branch=master)
[![License](https://img.shields.io/github/license/attachmentgenie/attachmentgenie-loki?stype=popout)](LICENSE)

Deploy and configure attachmentgenie's Loki on a node.

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

The simplest way to get started with this module is to add `include loki` to a manifest and create your config settings in Hiera. Additional details and examples are contained in [REFERENCE.md](REFERENCE.md).

## Reference

This module is documented via
`pdk bundle exec puppet strings generate --format markdown`.
Please see [REFERENCE.md](REFERENCE.md) for more info.

## Changelog

[CHANGELOG.md](CHANGELOG.md) is generated prior to each release via
`pdk bundle exec rake changelog`. This process relies on labels that are applied to each pull request.

## Limitations

At the moment, this module only supports Linux.

## Development

Acceptance tests for this module leverage [puppet_litmus](https://github.com/puppetlabs/puppet_litmus).
To run the acceptance tests follow the instructions [here](https://github.com/puppetlabs/puppet_litmus/wiki/Tutorial:-use-Litmus-to-execute-acceptance-tests-with-a-sample-module-(MoTD)#install-the-necessary-gems-for-the-module).
You can also find a tutorial and walkthrough of using Litmus and the PDK on [YouTube](https://www.youtube.com/watch?v=FYfR7ZEGHoE).
