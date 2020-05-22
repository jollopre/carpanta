require 'app/queries/show_customers'

RSpec.describe Carpanta::Queries::ShowCustomers do
  let!(:customer) { FactoryBot.create(:customer) }
  subject { described_class.new }

  describe '.call' do
    it 'returns customers' do
      result = subject.call

      expect(result).to include(
        have_attributes(
          name: customer.name,
          surname: customer.surname,
          email: customer.email,
          phone: customer.phone
        )
      )
    end
  end
end
