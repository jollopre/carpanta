require 'app/services/customers'
require 'app/services/tasks'
require 'app/repositories/customer'
require 'app/repositories/task'

Carpanta::Services::Customers.configure do |config|
  config.repository = Carpanta::Repositories::Customer
end

Carpanta::Services::Tasks.configure do |config|
  config.repository = Carpanta::Repositories::Task
end
