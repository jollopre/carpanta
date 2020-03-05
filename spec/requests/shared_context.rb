require 'rack/test'

RSpec.shared_context 'requests' do
  include Rack::Test::Methods
  let(:app) do
    Carpanta::Controllers::Application
  end
end
