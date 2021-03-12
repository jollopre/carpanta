require 'sinatra/base'

module Carpanta
  module Controllers
    class Base < Sinatra::Base
      configure do
        set :dump_errors, true
        set :environment, Carpanta.environment.to_sym
        set :haml, format: :html5
        set :logging, true
        set :raise_errors, development? || test?
        set :root, File.join(Carpanta.root, 'app')
        set :public_folder, Proc.new { File.join(root, 'public') }
        set :show_exceptions, false

        use Rack::CommonLogger, Carpanta.logger
      end

      configure :development do
        require 'sinatra/reloader'
        register Sinatra::Reloader
      end

      not_found do
        haml :not_found, layout: :layout
      end
    end
  end
end
