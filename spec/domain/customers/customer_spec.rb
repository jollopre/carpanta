require 'domain/customers/customer'

RSpec.describe Carpanta::Domain::Customers::Customer do
  describe '.build' do
    it 'returns a customer' do
      customer = FactoryBot.build(:customer)

      expect(customer.name).to eq('Donald')
      expect(customer.surname).to eq('Duck')
      expect(customer.email).to eq('donald.duck@carpanta.com')
      expect(customer.phone).to eq('600111222')
      expect(customer.id).to be_nil
      expect(customer.created_at).to be_nil
      expect(customer.updated_at).to be_nil
    end

    describe 'name' do
      it 'needs to be present' do
        customer = FactoryBot.build(:customer, name: nil)

        expect(customer.errors).to include(:name)
        expect(customer.errors.details).to include(
          name: include(
            error: :blank
          )
        )
      end
    end

    describe 'surname' do
      it 'needs to be present' do
        customer = FactoryBot.build(:customer, surname: nil)

        expect(customer.errors).to include(:surname)
        expect(customer.errors.details).to include(
          surname: include(
            error: :blank
          )
        )
      end
    end

    describe 'email' do
      it 'needs to be a valid format' do
        customer = FactoryBot.build(:customer, email: 'wadus@carpanta')

        expect(customer.errors).to include(:email)
        expect(customer.errors.details).to include(
          email: include(
            hash_including(error: :invalid, value: 'wadus@carpanta')
          )
        )
      end
    end
  end

  describe '#serializable_hash' do
    it 'returns a customer hash' do
      customer = FactoryBot.build(:customer)

      expect(customer.serializable_hash).to include(
        name: 'Donald',
        surname: 'Duck',
        email: 'donald.duck@carpanta.com',
        phone: '600111222',
        id: anything,
        created_at: anything,
        updated_at: anything
      )
    end
  end
end
