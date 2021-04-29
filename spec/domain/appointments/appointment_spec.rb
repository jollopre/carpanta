require "domain/appointments/appointment"

RSpec.describe Carpanta::Domain::Appointments::Appointment do
  describe "#ending_at" do
    let(:starting_at) { Time.new(2020, 12, 22, 8, 20, 0) }
    let(:duration) { 30 }
    let(:appointment) { FactoryBot.build(:appointment, starting_at: starting_at, duration: duration) }
    let(:ending_at) { Time.new(2020, 12, 22, 8, 50, 0) }

    it "returns starting_at + duration (min)" do
      expect(appointment.ending_at).to eq(ending_at)
    end
  end
end
