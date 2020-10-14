require 'domain/offers/services/create_offer'

RSpec.describe Carpanta::Domain::Offers::Services::CreateOffer do
  describe '.call' do
    let(:default_attributes) do
      {
        tasks: ['Cutting with scissor', 'Shampooing'],
        price: 2200
      }
    end

    context 'when the attributes are invalid' do
      let(:attributes) do
        default_attributes.merge(price: [1234])
      end

      it 'returns failure' do
        result = described_class.call(attributes)

        expect(result.failure).to include(
          price: include('must be an integer')
        )
      end
    end

    it 'returns the id created' do
      result = described_class.call(default_attributes)

      expect(result.value!).to match(/[0-9a-fA-F]{8}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{12}/)
      skip('check offer is persisted')
    end
  end
end
