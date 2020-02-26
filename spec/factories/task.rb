require 'app/entities/task'

FactoryBot.define do
  factory :task, class: Carpanta::Entities::Task do
    name { 'Dyeing Hair' }
    description { 'Dyeing Hair consist of ...' }
    price { 1500 }

    to_create do |record|
      new_record = Carpanta::Services::Tasks.create!(record.serializable_hash)
      record.attributes = new_record.attributes
    end
  end
end
