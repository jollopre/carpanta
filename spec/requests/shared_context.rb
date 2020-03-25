require 'rack/test'

RSpec.shared_context 'requests' do
  include Rack::Test::Methods
  include Capybara::RSpecMatchers

  let(:app) do
    Carpanta::Controllers::Application
  end
end
