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
      it 'raises RecordInvalid error' do
        attributes.merge!(email: 'wadus@')

        expect do
          described_class.create!(attributes)
        end.to raise_error(record_invalid, /Email is invalid/)
      end
    end

    context 'when the customer is not unique' do
      before do
        described_class.create!(attributes)
      end

      it 'raises RecordInvalid error' do
        expect do
          described_class.create!(attributes)
        end.to raise_error(record_invalid, /Email has already been taken/)
      end
    end
  end
end
