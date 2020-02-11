require 'app/services/customers/repository'

RSpec.describe Carpanta::Services::Customers::Repository do
  let(:storage) { described_class::Storage }
  let(:customer) { build(:customer) }
  let(:persisted_customer) { build(:customer, :persisted) }

  describe '.create' do
    it 'returns a persisted customer' do
      class_double(storage, create: persisted_customer).as_stubbed_const

      result = described_class.create(customer)

      expect(result.id).not_to be_nil
      expect(result.created_at).not_to be_nil
      expect(result.updated_at).not_to be_nil
    end

    context 'when the customer cannot be persisted' do
      let(:customer_with_errors) { build(:customer) }

      it 'returns a customer with errors' do
        customer_with_errors.errors.add(:email)
        class_double(storage, create: customer_with_errors).as_stubbed_const

        result = described_class.create(customer)

        expect(result.errors).not_to be_empty
      end
    end
  end
end
