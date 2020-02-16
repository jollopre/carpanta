require 'app/services/customers'
require 'spec/services/shared_context'

RSpec.describe Carpanta::Services::Customers do
  include_context 'services errors'
  
  describe '.create!' do
    let(:attributes) do
      FactoryBot.attributes_for(:customer)
    end

    it 'persists a customer' do
      result = described_class.create!(attributes)

      expect(result).to eq(true)
    end

    context 'when customer attributes are invalid' do
      it 'raise RecordInvalid error' do
        attributes.merge!(email: 'wadus@')

        expect do
          described_class.create!(attributes)
        end.to raise_error(record_invalid, /Email is invalid/)
      end
    end
  end
end
