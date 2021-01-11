require 'app/queries/show_appointments_by_starting_at'

RSpec.describe Carpanta::Queries::ShowAppointmentsByStartingAt do
  let(:start_time) { Time.new(2021,1,11,8,0,0) }
  let(:end_time) { Time.new(2021,1,11,22,0,0) }
  let!(:appointment1) { FactoryBot.create(:appointment, starting_at: start_time) }
  let!(:appointment2) { FactoryBot.create(:appointment, starting_at: end_time + 1) }

  describe '.call' do
    it 'returns success with appointments' do
      result = described_class.call(start_time: start_time, end_time: end_time)

      expect(result.success?).to eq(true)
      appointments = result.value!
      expect(appointments.size).to eq(1)
      expect(appointments.first.id).to eq(appointment1.id)
      expect(appointments.first.starting_at).to eq(appointment1.starting_at)
      expect(appointments.first.duration).to eq(appointment1.duration)
    end
  end
end
