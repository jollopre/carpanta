require 'app/queries/show_appointment'

RSpec.describe Carpanta::Queries::ShowAppointment do
  let(:customer) { FactoryBot.create(:customer) }
  let(:offer) { FactoryBot.create(:offer) }
  let!(:appointment) { FactoryBot.create(:appointment, customer_id: customer.id, offer_id: offer.id) }

  describe '.call' do
    it 'returns success with appointment information' do
      result = described_class.call(appointment.id)

      expect(result.success?).to eq(true)
      appointment = result.value!
      expect(appointment).to have_attributes(
        id: appointment.id,
        starting_at: appointment.starting_at,
        duration: appointment.duration,
        offer: have_attributes(
          name: 'Cutting with scissor and Shampooing'
        ),
        customer: have_attributes(
          name: customer.name,
          surname: customer.surname,
          email: customer.email,
          phone: customer.phone
        )
      )
    end

    context 'when appointment DOES NOT exist' do
      it 'returns failure' do
        result = described_class.call('non_existent')

        expect(result.failure?).to eq(true)
        expect(result.failure).to include(
          id: :not_found
        )
      end
    end
  end
end
