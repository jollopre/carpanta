require 'domain/customers/customer'

RSpec.describe Carpanta::Domain::Customers::Customer do
  describe '#to_h' do
    let(:attributes) do
      {
        name: 'Donald',
        surname: 'Duck',
        email: 'donald.duck@carpanta.com',
        phone: '600111222'
      }
    end

    subject do
      described_class.new(attributes)
    end

    it 'returns a hash with the attributes from customer' do
      result = subject.to_h

      expect(result).to include(
        id: anything,
        name: 'Donald',
        surname: 'Duck',
        email: 'donald.duck@carpanta.com',
        phone: '600111222'
      )
    end
  end
end
