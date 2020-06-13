require 'app'
require 'infra/logger'

Carpanta.configure do |config|
  config.root = ENV.fetch('ROOT_PATH')
  config.environment = ENV.fetch('RACK_ENV')
  config.logger = Infra::Logger.build
end
