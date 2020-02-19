require 'app/entities/task'
require 'app/services/tasks'

FactoryBot.define do
  factory :task, class: Carpanta::Entities::Task do
    name { 'Dyeing Hair' }
    description { 'Dyeing Hair consist of ...' }
    price { 1500 }

    transient do
      with_errors { false }
    end

    after(:build) do |task, evaluator|
      task.errors.add(:name) if evaluator.with_errors
    end

    to_create do |instance|
      Carpanta::Services::Tasks.create!(instance.serializable_hash)
    end
  end
end
