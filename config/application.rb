require_relative 'boot'
require 'sinatra/base'
require './app/dispatcher'

module Carpanta
  class Application < Sinatra::Base
    class << self
      def call(env)
        Dispatcher.call(env)
      end
    end
  end
end
