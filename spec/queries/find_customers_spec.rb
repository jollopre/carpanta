require 'app/queries/find_customers'

RSpec.describe Carpanta::Queries::FindCustomers do
  let!(:customer) { FactoryBot.create(:customer) }
  describe '.call' do
    it 'gets all the customers' do
      result = described_class.call

      expect(result).to include(have_attributes(name: customer.name, surname: customer.surname, email: customer.email, phone: customer.phone))
    end
  end
end
