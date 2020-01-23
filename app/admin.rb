require 'sinatra/base'

module Carpanta
  class Admin < Sinatra::Base
    get '/admin' do
      'Welcome to Carpanta Admin'
    end
  end
end
