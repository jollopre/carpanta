require 'app/commands/create_appointment'

RSpec.describe Carpanta::Commands::CreateAppointment do
  describe '.call' do
    let(:default_attributes) do
      FactoryBot.attributes_for(:appointment_legacy)
    end

    it 'returns success' do
      result = described_class.call(default_attributes)

      expect(result.success).to be_an_instance_of(String)
    end

    context 'when attributes are invalid' do
      let(:attributes) do
        default_attributes.merge(starting_at: nil)
      end

      it 'returns failure' do
        result = described_class.call(attributes)

        expect(result.failure).to include(
          starting_at: include("can't be blank")
        )
      end
    end
  end
end
