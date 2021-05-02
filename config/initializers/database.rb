require "infra/database"

Infra::Database.configure do |config|
  config.root = Carpanta.root
  config.environment = Carpanta.environment
  config.logger = Carpanta.logger
end

Infra::Database.connect!
