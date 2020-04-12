require_relative 'base'
require_relative 'customers'
require_relative 'sessions'

module Carpanta
  module Controllers
    class Application < Base
      use Customers
      use Sessions

      get '/carpanta.css' do
        send_file File.join(Carpanta.root, 'app', 'assets', 'carpanta.css')
      end

      get '/' do
        redirect('/customers')
      end
    end
  end
end
