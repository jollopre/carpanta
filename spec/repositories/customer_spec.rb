require 'app/repositories/customer'
require 'app/entities/customer'

RSpec.describe Carpanta::Repositories::Customer do
  describe '.create!' do
    let(:customer) do
      FactoryBot.build(:customer)
    end

    it 'persists a customer' do
      result = described_class.create!(customer)

      expect(result).to be_an_instance_of(Carpanta::Entities::Customer)
      expect(result.id).not_to be_nil
      expect(result.created_at).not_to be_nil
      expect(result.updated_at).not_to be_nil
    end
  end
end
