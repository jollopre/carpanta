require 'rack/test'
require_relative '../../config/boot'

RSpec.describe Carpanta::Routes::Application do
  include Rack::Test::Methods

  def app
    Carpanta::Routes::Application
  end

  describe '/admin' do
    it 'returns 200' do
      get '/admin'

      expect(last_response.status).to eq(200)
    end

    it 'returns welcome message' do
      get '/admin'

      expect(last_response.body).to eq('Welcome to Carpanta Admin')
    end
  end
end
