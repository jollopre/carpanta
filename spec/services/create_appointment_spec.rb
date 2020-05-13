require 'app/services/create_appointment'
require 'domain/appointments/repository'
require 'domain/customers/repository'
require 'domain/offers/repository'

RSpec.describe Carpanta::Services::CreateAppointment do
  let(:repository_class) do
    Carpanta::Domain::Appointments::Repository
  end
  let(:customer_repository_class) do
    Carpanta::Domain::Customers::Repository
  end
  let(:offer_repository_class) do
    Carpanta::Domain::Offers::Repository
  end

  before do
    described_class.configure do |config|
      config.repository = repository_class
      config.customer_repository = customer_repository_class
      config.offer_repository = offer_repository_class
    end
  end

  after do
    described_class.configure do |config|
      config.repository = nil
      config.customer_repository = nil
      config.offer_repository = nil
    end
  end

  describe '.call' do
    let(:customer) do
      FactoryBot.create(:customer)
    end
    let(:offer) do
      FactoryBot.create(:offer)
    end
    let(:default_attributes) do
      FactoryBot.attributes_for(:appointment, customer_id: customer.id, offer_id: offer.id)
    end

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
          default_attributes.merge(customer_id: 'not_found')
        end

        it 'returns customer_id error including not_found' do
          appointment = described_class.call(attributes)

          expect(appointment.errors.details).to include(
            customer_id: include(
              error: :not_found
            )
          )
        end
      end

      context 'since offer does not exist' do
        let(:attributes) do
          default_attributes.merge(offer_id: 'not_found')
        end

        it 'returns offer_id error including not_found' do
          appointment = described_class.call(attributes)

          expect(appointment.errors.details).to include(
            offer_id: include(
              error: :not_found
            )
          )
        end
      end
    end
  end
end
