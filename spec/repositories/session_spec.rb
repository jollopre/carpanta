require 'app/services/tasks'
require 'app/repositories/session'
require 'app/entities/session'
require_relative 'shared_examples'

RSpec.describe Carpanta::Repositories::Session do
  describe '.create!' do
    let(:customer) do
      FactoryBot.create(:customer)
    end
    let(:task) do
      FactoryBot.create(:task)
    end
    let(:entity) do
      FactoryBot.build(:session, task_id: task.id, customer_id: customer.id)
    end
    let(:entity_class) do
      Carpanta::Entities::Session
    end

    it_behaves_like 'repository creation'
  end
end
