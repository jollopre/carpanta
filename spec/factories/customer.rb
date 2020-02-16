require 'app/services/customers/model'

FactoryBot.define do
  factory :customer, class: "Carpanta::Services::Customers::Model" do
    name { 'Donald' }
    surname { 'Duck' }
    email { 'donald.duck@carpanta.com' }
    phone { '600111222' }
  end
end
