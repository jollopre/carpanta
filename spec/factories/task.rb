require 'app/services/tasks/model'

FactoryBot.define do
  factory :task, class: "Carpanta::Services::Tasks::Model" do
    name { 'Dyeing Hair' }
    description { 'Dyeing Hair consist of ...' }
    price { 1500 }

    transient do
      with_errors { false }
    end

    after(:build) do |task, evaluator|
      task.errors.add(:name) if evaluator.with_errors
    end
  end
end
