require 'domain/customers/customer'
require 'domain/customers/customer_repository'

RSpec.describe Carpanta::Domain::Customers::CustomerRepository do
  let(:customer) do
    Carpanta::Domain::Customers::Customer.build(name: 'Donald', surname: 'Duck', email: 'donald.duck@carpanta.com', phone: '666111222')
  end

  describe '.create!' do
    it 'inserts a customer into its repository' do
      result = described_class.create!(customer)

      expect(result.id).not_to be_nil
      expect(result.created_at).not_to be_nil
      expect(result.updated_at).not_to be_nil
      expect(result).to be_an_instance_of(Carpanta::Domain::Customers::Customer)
    end
  end

  describe '.exists?' do
    context 'when customer email already exists' do
      before do
        described_class.create!(customer)
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

  describe '.find_all' do
    let(:storage) do
      Carpanta::Domain::Customers::CustomerStorage
    end

    before do
      described_class.create!(customer)
    end

    it 'returns customers' do
      result = described_class.find_all

      expect(result).to include(customer)
    end
  end

  describe '.find_by_id' do
    it 'returns a customer instance' do
      persisted_customer = described_class.create!(customer)

      result = described_class.find_by_id(persisted_customer.id)

      expect(result).to eq(persisted_customer)
    end

    context 'when there is no customer for the id' do
      it 'returns nil' do
        result = described_class.find_by_id('an_id')

        expect(result).to be_nil
      end
    end
  end
end
