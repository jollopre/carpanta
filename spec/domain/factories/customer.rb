require 'domain/customers/customer'
require 'domain/customers/repository'

FactoryBot.define do
  factory :customer, class: Carpanta::Domain::Customers::Customer do
    name { 'Donald' }
    surname { 'Duck' }
    email { 'donald.duck@carpanta.com' }
    phone { '600111222' }

    initialize_with do
      Carpanta::Domain::Customers::Customer.new(attributes)
    end

    to_create do |instance|
      repository = Carpanta::Domain::Customers::Repository.new
      repository.save(instance).value!
    end
  end
end
