# @summary List of loki components
type Loki::Target = Enum[
  'all',
  'compactor',
  'distributor',
  'ingester',
  'querier',
  'query-scheduler',
  'ingester-querier',
  'query-frontend',
  'index-gateway',
  'ruler',
  'table-manager',
  'read',
  'write' # lint:ignore:trailing_comma
]
