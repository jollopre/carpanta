require 'sinatra/base'

module Carpanta
  module Controllers
    class Base < Sinatra::Base
      configure do
        set :root, File.join(ENV.fetch('ROOT_PATH'), 'app')
        set :haml, format: :html5
        set :environment, ENV.fetch('RACK_ENV')
        set :logging, true

        file = File.new(File.join(ENV.fetch('ROOT_PATH'), 'log', ENV.fetch('RACK_ENV') + '.log'), 'a+')
        file.sync = true
        use Rack::CommonLogger, file
      end
    end
  end
end
