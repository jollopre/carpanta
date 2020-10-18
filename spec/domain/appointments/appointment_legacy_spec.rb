require 'domain/appointments/appointment_legacy'

RSpec.describe Carpanta::Domain::Appointments::AppointmentLegacy do
  let(:appointment) do
    FactoryBot.build(:appointment_legacy)
  end

  describe '.build' do
    it 'returns an appointment' do
      expect(appointment.id).not_to be_nil
      expect(appointment.starting_at).to eq(Time.new(2020, 05, 06, 8, 25, 12))
      expect(appointment.customer_id).not_to be_nil
      expect(appointment.offer_id).not_to be_nil
      expect(appointment.duration).to be_nil
    end

    it 'there are no errors' do
      expect(appointment.errors).to be_empty
    end

    describe 'customer_id' do
      it 'needs to be present' do
        appointment = FactoryBot.build(:appointment_legacy, customer_id: nil)

        expect(appointment.errors.details).to include(
          customer_id: include(
            error: :blank
          )
        )
      end
    end

    describe 'offer_id' do
      it 'needs to be present' do
        appointment = FactoryBot.build(:appointment_legacy, offer_id: nil)

        expect(appointment.errors.details).to include(
          offer_id: include(
            error: :blank
          )
        )
      end
    end

    describe 'starting_at' do
      it 'needs to be present' do
        appointment = FactoryBot.build(:appointment_legacy, starting_at: nil)

        expect(appointment.errors.details).to include(
          starting_at: include(
            error: :blank
          )
        )
      end

      it 'needs to be a time instance' do
        skip('check the gem https://github.com/adzap/validates_timeliness')
      end
    end

    describe 'duration' do
      context 'numericality' do
        it 'needs to be integer' do
          appointment = FactoryBot.build(:appointment_legacy, duration: 50.00)

          expect(appointment.errors.details).to include(
            duration: include(
              error: :not_an_integer,
              value: 50.00
            )
          )
        end

        it 'needs to be positive' do
          appointment = FactoryBot.build(:appointment_legacy, duration: -50)

          expect(appointment.errors.details).to include(
            duration: include(
              count: 0,
              error: :greater_than,
              value: -50
            )
          )
        end

        it 'needs to be greater than zero' do
          appointment = FactoryBot.build(:appointment_legacy, duration: 0)

          expect(appointment.errors.details).to include(
            duration: include(
              count: 0,
              error: :greater_than,
              value: 0
            )
          )
        end
      end
    end
  end

  describe '#attributes' do
    it 'returns an appointment hash' do
      expect(appointment.attributes).to include(
        id: an_instance_of(String),
        starting_at: an_instance_of(Time),
        duration: anything,
        customer_id: anything,
        offer_id: anything
      )
    end
  end
end
