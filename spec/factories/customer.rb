require 'app/services/customers/model'
require 'app/services/customers'

FactoryBot.define do
  factory :customer, class: Carpanta::Services::Customers::Model do
    name { 'Donald' }
    surname { 'Duck' }
    email { 'donald.duck@carpanta.com' }
    phone { '600111222' }

    to_create do |instance|
      Carpanta::Services::Customers.create!(instance.serializable_hash)
    end
  end
end
