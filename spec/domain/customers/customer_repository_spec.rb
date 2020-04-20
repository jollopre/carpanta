require 'domain/customers/customer'
require 'domain/customers/customer_repository'

RSpec.describe Carpanta::Domain::Customers::CustomerRepository do
  describe '.create!' do
    it 'inserts a customer into its repository' do
      customer = Carpanta::Domain::Customers::Customer.from_params(name: 'Donald', surname: 'Duck', email: 'donald.duck@carpanta.com', phone: '666111222')

      result = described_class.create!(customer)

      expect(result.id).not_to be_nil
      expect(result.created_at).not_to be_nil
      expect(result.updated_at).not_to be_nil
      expect(result).to be_an_instance_of(Carpanta::Domain::Customers::Customer)
    end
  end
end
