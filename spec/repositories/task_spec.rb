require 'app/repositories/task'
require 'app/entities/task'

RSpec.describe Carpanta::Repositories::Task do
  describe '.create!' do
    let(:task) do
      FactoryBot.build(:task)
    end

    it 'persists a customer' do
      result = described_class.create!(task)

      expect(result).to be_an_instance_of(Carpanta::Entities::Task)
      expect(result.id).not_to be_nil
      expect(result.created_at).not_to be_nil
      expect(result.updated_at).not_to be_nil
    end
  end
end
