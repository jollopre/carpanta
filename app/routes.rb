require 'sinatra/base'
require_relative 'routes/admin'

module Carpanta
  module Routes
    class Application < Sinatra::Base
      use Admin::Application
    end
  end
end
