require 'sinatra/base'

module Carpanta
  module Controllers
    class Base < Sinatra::Base
      set :root, File.join(ENV.fetch('ROOT_PATH'), 'app')
      set :haml, format: :html5
    end
  end
end
