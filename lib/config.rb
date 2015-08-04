require 'yaml'

config = YAML.load_file("./config.yml")[ENV['RACK_ENV']]
Settings = OpenStruct.new(config)