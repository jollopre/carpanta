require 'app/services/customers'
require 'app/entities/customer'
require 'spec/services/shared_context'

RSpec.describe Carpanta::Services::Customers do
  include_context 'services errors'
  
  describe '.create!' do
    let(:attributes) do
      FactoryBot.attributes_for(:customer)
    end
    let(:entity) do
      Carpanta::Entities::Customer
    end
    let(:repository) do
      described_class.configuration.repository
    end

    it 'forwards into its repository with a customer' do
      class_double(repository).as_stubbed_const

      expect(repository).to receive(:create!) do |customer|
        expect(customer.name).to eq('Donald')
        expect(customer.surname).to eq('Duck')
        expect(customer.email).to eq('donald.duck@carpanta.com')
        expect(customer.phone).to eq('600111222')
      end

      described_class.create!(attributes)
    end

    context 'when customer attributes are invalid' do
      it 'raises RecordInvalid error' do
        attributes.merge!(email: 'wadus@')

        expect do
          described_class.create!(attributes)
        end.to raise_error(record_invalid, /Email is invalid/)
      end
    end

    context 'when the customer email is duplicated' do
      it 'raises RecordNotUnique error'
    end
  end
end
