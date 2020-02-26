require 'app/entities/session'

FactoryBot.define do
  factory :session, class: Carpanta::Entities::Session do
    price { 1500 }

    to_create do |record|
      new_record = Carpanta::Services::Sessions.create!(record.serializable_hash)
      record.attributes = new_record.attributes
    end
  end
end
