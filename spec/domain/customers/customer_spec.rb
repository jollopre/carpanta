require 'domain/customers/customer'

RSpec.describe Carpanta::Domain::Customers::Customer do
  describe '.build' do
    it 'returns a customer' do
      customer = FactoryBot.build(:customer)

      expect(customer.id).not_to be_nil
      expect(customer.name).to eq('Donald')
      expect(customer.surname).to eq('Duck')
      expect(customer.email).to eq('donald.duck@carpanta.com')
      expect(customer.phone).to eq('600111222')
    end

    it 'there are no errors' do
      customer = FactoryBot.build(:customer)

      expect(customer.errors).to be_empty
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

  describe '#attributes' do
    it 'returns a customer hash' do
      customer = FactoryBot.build(:customer)

      expect(customer.attributes).to include(
        name: 'Donald',
        surname: 'Duck',
        email: 'donald.duck@carpanta.com',
        phone: '600111222',
        id: anything,
      )
    end
  end
end
