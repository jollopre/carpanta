require 'domain/customers/customer_legacy'

FactoryBot.define do
  factory :customer_legacy, class: Carpanta::Domain::Customers::CustomerLegacy do
    name { 'Donald' }
    surname { 'Duck' }
    email { 'donald.duck@carpanta.com' }
    phone { '600111222' }

    initialize_with do
      Carpanta::Domain::Customers::CustomerLegacy.build(attributes)
    end
  end
end
