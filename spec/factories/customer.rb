require 'app/entities/customer'

FactoryBot.define do
  factory :customer, class: Carpanta::Entities::Customer do
    name { 'Donald' }
    surname { 'Duck' }
    email { 'donald.duck@carpanta.com' }
    phone { '600111222' }

    to_create do |record|
      new_record = Carpanta::Services::Customers.create!(record.serializable_hash)
      record.attributes = new_record.attributes
    end
  end
end
