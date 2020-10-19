require 'app/queries/show_customer'

RSpec.describe Carpanta::Queries::ShowCustomer do
  let(:customer) { FactoryBot.create(:customer) }
  let(:offer) { FactoryBot.create(:offer) }
  let!(:appointment) { FactoryBot.create(:appointment, customer_id: customer.id, offer_id: offer.id) }

  describe '.call' do
    it 'returns success with customer information' do
      result = described_class.call(customer.id)

      expect(result.success?).to eq(true)
      customer = result.value!
      expect(customer.id).to eq(customer.id)
      expect(customer.name).to eq(customer.name)
      expect(customer.surname).to eq(customer.surname)
      expect(customer.email).to eq(customer.email)
      expect(customer.phone).to eq(customer.phone)
    end

    context 'appointments' do
      it 'returns appointment information' do
        result = described_class.call(customer.id)

        customer = result.value!
        expect(customer.appointments).to include(
          have_attributes(
            starting_at: appointment.starting_at,
            duration: appointment.duration
          )
        )
      end

      it 'returns offer name associated' do
        result = described_class.call(customer.id)

        customer = result.value!
        expect(customer.appointments.first.offer.name).to eq('Cutting with scissor and Shampooing')
      end
    end

    context 'when customer DOES NOT exist' do
      it 'returns failure' do
        result = subject.call('non_existent')

        expect(result.failure?).to eq(true)
        expect(result.failure).to include(
          id: :not_found
        )
      end
    end
  end
end
