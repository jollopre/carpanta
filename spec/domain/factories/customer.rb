require 'domain/customers/customer'
require 'infra/orm'

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
      Infra::ORM::Customer.create!(
        id: instance.id,
        name: instance.name,
        surname: instance.surname,
        email: instance.email,
        phone: instance.phone
      )
    end
  end
end
