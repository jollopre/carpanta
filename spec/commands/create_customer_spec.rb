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

    context 'when the attributes are invalid' do
      let(:attributes) do
        default_attributes.merge(email: 'donald@')
      end

      it 'returns failure' do
        result = described_class.call(attributes)

        expect(result.failure).to include(
          email: include('is in invalid format')
        )
      end
    end

    it 'returns the id created' do
      result = described_class.call(default_attributes)

      expect(result.value!).to eq('an_id')
    end
  end
end
