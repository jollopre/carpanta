require 'sinatra/base'

module Carpanta
  module Controllers
    class Base < Sinatra::Base
      configure do
        set :root, File.join(Carpanta.root, 'app')
        set :haml, format: :html5
        set :environment, Carpanta.environment
        set :logging, true

        use Rack::CommonLogger, Carpanta.logger
      end
    end
  end
end
