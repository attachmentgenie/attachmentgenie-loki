# A function to strip the --- from the beginning of a string
Puppet::Functions.create_function(:'loki::strip_yaml_header') do
  # @param yaml_string
  #   A string that may start with the ---'s used to denote a YAML file
  # @return [String]
  #   Returns the string with the leading header stripped off
  # @example
  #   concat::fragment { 'loki_common_config':
  #     target  => $config_file,
  #     content => $loki::common_config_hash.stdlib::to_yaml.loki::strip_yaml_header,
  #     order   => '09',
  #   }
  #
  dispatch :strip_header do
    param 'String', :yaml_string
    return_type 'String'
  end

  def strip_header(yaml_string)
    yaml_string.gsub(%r{^---\s}, '')
  end
end
