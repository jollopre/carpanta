require "factory_bot"

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods

  config.before(:suite) do
    FactoryBot.definition_file_paths = %w[spec/domain/factories]
    FactoryBot.find_definitions
  end
end
