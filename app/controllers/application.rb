require_relative 'base'
require_relative 'customers'

module Carpanta
  module Controllers
    class Application < Base
      use Customers

      get '/main.js' do
        send_file File.join(Carpanta.root, 'app', 'assets', 'main.js')
      end

      get '/' do
        redirect('/customers')
      end
    end
  end
end
