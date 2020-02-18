require 'app/entities/session'

FactoryBot.define do
  factory :session, class: Carpanta::Entities::Session do
    price { 1500 }
  end
end
