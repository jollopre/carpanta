require 'app/queries/find_customers'

RSpec.describe Carpanta::Queries::FindCustomers do
  let!(:customer) { FactoryBot.create(:customer) }

  describe '.call' do
    it 'gets all the customers' do
      result = described_class.call

      expect(result).to include(have_attributes(name: customer.name, surname: customer.surname, email: customer.email, phone: customer.phone))
    end

    context 'when params are sent' do
      let(:customer) { FactoryBot.create(:customer) }
      let!(:another_customer) { FactoryBot.create(:customer, email: 'wadus@carpanta.com') }

      context 'with id' do
        let(:params) { { id: [customer.id] } }

        it 'filters by customer_id' do
          result = described_class.call(params)

          expect(result).to include(have_attributes(id: customer.id))
          expect(result.size).to eq(1)
        end
      end
    end
  end
end
