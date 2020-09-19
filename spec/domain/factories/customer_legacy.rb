require 'domain/customers/customer_legacy'
require 'domain/customers/repository_legacy'

FactoryBot.define do
  factory :customer, class: Carpanta::Domain::Customers::CustomerLegacy do
    name { 'Donald' }
    surname { 'Duck' }
    email { 'donald.duck@carpanta.com' }
    phone { '600111222' }

    initialize_with do
      Carpanta::Domain::Customers::CustomerLegacy.build(attributes)
    end

    to_create do |instance|
      Carpanta::Domain::Customers::RepositoryLegacy.save!(instance)
    end
  end
end
