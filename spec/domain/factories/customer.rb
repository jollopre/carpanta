require 'domain/customers/customer'
require 'domain/customers/repository'

FactoryBot.define do
  factory :customer, class: Carpanta::Domain::Customers::Customer do
    name { 'Donald' }
    surname { 'Duck' }
    email { 'donald.duck@carpanta.com' }
    phone { '600111222' }

    initialize_with do
      Carpanta::Domain::Customers::Customer.build(attributes)
    end

    to_create do |instance|
      Carpanta::Domain::Customers::Repository.create!(instance)
    end
  end
end
