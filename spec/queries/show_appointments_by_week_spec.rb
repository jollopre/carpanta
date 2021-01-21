require 'app/queries/show_appointments_by_week'

RSpec.describe Carpanta::Queries::ShowAppointmentsByWeek do
  let(:date) { '2021-01-14' }
  let!(:appointment0) { FactoryBot.create(:appointment, starting_at: Time.new(2021,1,10,6,0,0)) }
  let!(:appointment1) { FactoryBot.create(:appointment, starting_at: Time.new(2021,1,11,6,0,0)) }
  let!(:appointment2) { FactoryBot.create(:appointment, starting_at: Time.new(2021,1,17,21,0,0)) }
  let!(:appointment3) { FactoryBot.create(:appointment, starting_at: Time.new(2021,1,18,6,0,0)) }

  describe '.call' do
    context 'when date is invalid' do
      it 'returns failure' do
        result = described_class.call(date: 'foo')

        expect(result.failure?).to eq(true)
        expect(result.failure).to include(
          date: include('must be a date')
        )
      end
    end

    it 'returns success with appointments' do
      result = described_class.call(date: date)

      expect(result.success?).to eq(true)
      appointments = result.value!
      expect(appointments.size).to eq(2)
      expect(appointments.first.id).to eq(appointment1.id)
      expect(appointments.first.starting_at).to eq(appointment1.starting_at)
      expect(appointments.first.duration).to eq(appointment1.duration)
      expect(appointments.second.id).to eq(appointment2.id)
      expect(appointments.second.starting_at).to eq(appointment2.starting_at)
      expect(appointments.second.duration).to eq(appointment2.duration)
    end
  end
end
