require 'app/queries/show_customer'

RSpec.describe Carpanta::Queries::ShowCustomer do
  let(:customer) { FactoryBot.create(:customer_legacy) }
  let(:offer) { FactoryBot.create(:offer) }
  let!(:appointment) { FactoryBot.create(:appointment, customer_id: customer.id, offer_id: offer.id) }
  subject { described_class.new }

  describe '.call' do
    it 'returns customer information' do
      result = subject.call(customer.id)

      expect(result.id).to eq(customer.id)
      expect(result.name).to eq(customer.name)
      expect(result.surname).to eq(customer.surname)
      expect(result.email).to eq(customer.email)
      expect(result.phone).to eq(customer.phone)
    end

    context 'appointments' do
      it 'returns appointment information' do
        result = subject.call(customer.id)

        expect(result.appointments).to include(
          have_attributes(
            starting_at: appointment.starting_at,
            duration: appointment.duration
          )
        )
      end

      it 'returns offer name associated' do
        result = subject.call(customer.id)

        expect(result.appointments.first.offer.name).to eq('Cutting with scissor and Shampooing')
      end
    end

    context 'when customer DOES NOT exist' do
      it 'returns nil' do
        result = subject.call('non_existent')

        expect(result).to be_nil
      end
    end
  end
end
