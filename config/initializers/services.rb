require 'app/services/customers'
require 'app/repositories/customer'

Carpanta::Services::Customers.configure do |config|
  config.repository = Carpanta::Repositories::Customer
end
