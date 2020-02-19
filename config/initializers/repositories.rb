require 'app/repositories/customer'
require 'app/repositories/session'
require 'app/repositories/task'
require 'app/storage'

Carpanta::Repositories::Customer.configure do |config|
  config.storage = Carpanta::Storage::Customer
end

Carpanta::Repositories::Session.configure do |config|
  config.storage = Carpanta::Storage::Session
end

Carpanta::Repositories::Task.configure do |config|
  config.storage = Carpanta::Storage::Task
end
