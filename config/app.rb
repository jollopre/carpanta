require 'app'

Carpanta.configure do |config|
  config.root = ENV.fetch('ROOT_PATH')
  config.environment = ENV.fetch('RACK_ENV')

  file = File.new(File.join(config.root, 'log', config.environment + '.log'), 'a+')
  file.sync = true
  config.logger = Logger.new(file)
end
