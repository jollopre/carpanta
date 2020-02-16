require 'app/services/customers'
require 'app/services/sessions'
require 'app/services/tasks'
require 'app/repositories/customer'
require 'app/repositories/session'
require 'app/repositories/task'

Carpanta::Services::Customers.configure do |config|
  config.repository = Carpanta::Repositories::Customer
end

Carpanta::Services::Sessions.configure do |config|
  config.repository = Carpanta::Repositories::Session
end

Carpanta::Services::Tasks.configure do |config|
  config.repository = Carpanta::Repositories::Task
end
