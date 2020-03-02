require 'app/entities/customer'

RSpec.describe Carpanta::Entities::Customer do
  describe '.initialize' do
    it 'returns an instance responding to customer attributes' do
      customer = FactoryBot.build(:customer)
      
      expect(customer).to respond_to(:id)
      expect(customer.name).to eq('Donald')
      expect(customer.surname).to eq('Duck')
      expect(customer.email).to eq('donald.duck@carpanta.com')
      expect(customer.phone).to eq('600111222')
      expect(customer).to respond_to(:created_at)
      expect(customer).to respond_to(:updated_at)
    end
  end

  context 'email' do
    it 'when email does not match the regex' do
      customer = FactoryBot.build(:customer, email: '@carpanta.com')

      expect(customer.valid?).to eq(false)
    end

    it 'errors includes email' do
      customer = FactoryBot.build(:customer, email: '@carpanta.com')

      customer.valid?

      expect(customer.errors).to include(:email)
    end
  end

  describe '#serializable_hash' do
    it 'returns a hash representing the model attributes' do
      customer = FactoryBot.build(:customer)

      result = customer.serializable_hash

      expect(result).to include(:id, :name, :surname, :email, :phone, :created_at, :updated_at)
    end
  end
end
