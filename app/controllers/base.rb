require 'sinatra/base'

module Carpanta
  module Controllers
    class Base < Sinatra::Base
      configure do
        set :environment, Carpanta.environment.to_sym
        set :logging, true
        set :root, File.join(Carpanta.root, 'app')
        set :run, false
        set :dump_errors, true
        set :show_exceptions, development? || test?
        set :haml, format: :html5

        use Rack::CommonLogger, Carpanta.logger
      end

      configure :development do
        require 'sinatra/reloader'
        register Sinatra::Reloader
      end
    end
  end
end
