FactoryBot.define do
  trait :persisted do
    id { Random.new.rand(100) } 
    created_at { Time.now }
    updated_at { Time.now }
  end
end
