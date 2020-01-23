require 'sinatra/base'
require './app/admin'
require './app/root_application'

module Carpanta
  class Dispatcher < Sinatra::Base
    class << self
      def call(env)
        path_info = env.fetch('PATH_INFO')

        case path_info
        when '/admin' then Carpanta::Admin.call(env)
        else Carpanta::RootApplication.call(env)
        end
      end
    end
  end
end
