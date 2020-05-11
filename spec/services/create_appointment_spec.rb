require 'app/services/create_appointment'
require 'domain/appointments/repository'

RSpec.describe Carpanta::Services::CreateAppointment do
  let(:default_attributes) do
    FactoryBot.attributes_for(:appointment)
  end
  let(:repository_class) do
    described_class.configuration.repository
  end

  before do
    described_class.configure do |config|
      config.repository = Carpanta::Domain::Appointments::Repository
    end

    class_double(repository_class).as_stubbed_const
  end

  describe '.call' do
    it 'persists the appointment' do
      allow(repository_class).to receive(:save!)

      appointment = described_class.call(default_attributes)

      expect(repository_class).to have_received(:save!).with(appointment)
    end

    it 'returns an appointment' do
      result = described_class.call(default_attributes)

      expect(result.errors).to be_empty
    end

    context 'when the appointment is invalid' do
      let(:attributes) do
        default_attributes.merge(starting_at: nil)
      end

      it 'returns with errors' do
        appointment = described_class.call(attributes)

        expect(appointment.errors.details).to include(
          starting_at: include(
            error: :blank
          )
        )
      end

      context 'since customer does not exist' do
        let(:attributes) do
          default_attributes.merge(customer_id: 'foo')
        end

        it 'returns customer_id error including not_found' do
          appointment = described_class.call(attributes)
          skip

          expect(appointment.errors.details).to include(
            customer_id: include(
              error: :not_found
            )
          )
        end
      end
    end
  end
end
