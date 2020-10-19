require 'app/commands/create_customer'

RSpec.describe Carpanta::Commands::CreateCustomer do
  describe '.call' do
    let(:default_attributes) do
      {
        name: 'Donald',
        surname: 'Duck',
        email: 'donald.duck@carpanta.com'
      }
    end

    it 'forwards into customers domain for creating customer' do
      expect(Carpanta::Domain::Customers::Services::CreateCustomer).to receive(:call).with(default_attributes)

      described_class.call(default_attributes)
    end
  end
end
