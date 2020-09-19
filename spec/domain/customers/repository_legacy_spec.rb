require 'domain/customers/customer_legacy'
require 'domain/customers/repository_legacy'
require 'domain/customers/errors'

RSpec.describe Carpanta::Domain::Customers::RepositoryLegacy do
  let(:customer) do
    FactoryBot.build(:customer)
  end
  let(:not_found_class) do
    Carpanta::Domain::Customers::Errors::NotFound
  end

  describe '.save!' do
    it 'returns true' do
      result = described_class.save!(customer)

      expect(result).to eq(true)
    end
  end

  describe '.exists?' do
    context 'when customer email already exists' do
      before do
        described_class.save!(customer)
      end

      it 'returns true' do
        result = described_class.exists?(customer)

        expect(result).to eq(true)
      end
    end

    it 'returns false' do
      result = described_class.exists?(customer)

      expect(result).to eq(false)
    end
  end

  describe '.find_by_id!' do
    it 'returns a customer instance' do
      described_class.save!(customer)

      result = described_class.find_by_id!(customer.id)

      expect(result).to eq(customer)
    end

    context 'when there is no customer for the id' do
      it 'raises NotFound' do
        expect do
          described_class.find_by_id!('non_existent')
        end.to raise_error(not_found_class)
      end
    end
  end
end
