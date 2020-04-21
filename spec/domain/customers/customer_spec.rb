require 'domain/customers/customer'

RSpec.describe Carpanta::Domain::Customers::Customer do
  describe '.from_params' do
    it 'returns a customer' do
      customer = described_class.from_params(name: 'Donald', surname: 'Duck', email: 'donald.duck@carpanta.com', phone: '666111222')

      expect(customer.name).to eq('Donald')
      expect(customer.surname).to eq('Duck')
      expect(customer.email).to eq('donald.duck@carpanta.com')
      expect(customer.phone).to eq('666111222')
      expect(customer.id).to be_nil
      expect(customer.created_at).to be_nil
      expect(customer.updated_at).to be_nil
    end

    describe 'name' do
      it 'needs to be present' do
        customer = described_class.from_params(name: nil)

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
        customer = described_class.from_params(surname: nil)

        expect(customer.errors).to include(:surname)
        expect(customer.errors.details).to include(
          name: include(
            error: :blank
          )
        )
      end
    end

    describe 'email' do
      it 'needs to be a valid format' do
        customer = described_class.from_params(email: 'wadus@carpanta')

        expect(customer.errors).to include(:email)
        expect(customer.errors.details).to include(
          email: include(
            hash_including(error: :invalid, value: 'wadus@carpanta')
          )
        )
      end

      it 'must be unique in the system' do
        pending('TODO after repository is created')
      end
    end
  end

  describe '#serializable_hash' do
    it 'returns a customer hash' do
      customer = described_class.from_params(name: 'Donald', surname: 'Duck', email: 'donald.duck@carpanta.com', phone: '666111222')

      expect(customer.serializable_hash).to include(
        name: 'Donald',
        surname: 'Duck',
        email: 'donald.duck@carpanta.com',
        phone: '666111222',
        id: anything,
        created_at: anything,
        updated_at: anything
      )
    end
  end
end
