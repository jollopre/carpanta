require 'app/services/sessions/model'

FactoryBot.define do
  factory :session, class: Carpanta::Services::Sessions::Model do
    price { 1500 }
  end
end
