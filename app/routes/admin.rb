require 'sinatra/base'

module Carpanta
  module Routes
    module Admin
      class Application < Sinatra::Base
        get ('/admin') do
          'Welcome to Carpanta Admin'
        end
      end
    end
  end
end
