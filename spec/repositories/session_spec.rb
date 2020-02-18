require 'app/services/customers'
require 'app/services/tasks'
require 'app/repositories/session'
require 'app/entities/session'

RSpec.describe Carpanta::Repositories::Session do
  describe '.create!' do
    let(:customer) do
      FactoryBot.create(:customer)
    end
    let(:task) do
      FactoryBot.create(:task)
    end
    let(:session) do
      FactoryBot.build(:session, task_id: task.id, customer_id: customer.id)
    end

    it 'persists a session' do
      result = described_class.create!(session)

      expect(result).to be_an_instance_of(Carpanta::Entities::Session)
      expect(result.id).not_to be_nil
      expect(result.created_at).not_to be_nil
      expect(result.updated_at).not_to be_nil
    end
  end
end
