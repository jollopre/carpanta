require "app/queries/show_weekly_calendar"

RSpec.describe Carpanta::Queries::ShowWeeklyCalendar do
  let(:date) { "2021-01-14" }
  let!(:appointment0) { FactoryBot.create(:appointment, starting_at: Time.new(2021, 1, 10, 6, 0, 0)) }
  let!(:appointment1) { FactoryBot.create(:appointment, starting_at: Time.new(2021, 1, 11, 6, 0, 0)) }
  let!(:appointment2) { FactoryBot.create(:appointment, starting_at: Time.new(2021, 1, 17, 21, 0, 0)) }
  let!(:appointment3) { FactoryBot.create(:appointment, starting_at: Time.new(2021, 1, 18, 6, 0, 0)) }

  describe ".call" do
    context "when date is invalid" do
      it "returns failure" do
        result = described_class.call(date: "foo")

        expect(result.failure?).to eq(true)
        expect(result.failure).to include(
          date: include("must be a date")
        )
      end
    end

    it "returns success with calendar appointments" do
      result = described_class.call(date: date)

      expect(result.success?).to eq(true)
      calendar = result.value!
      date = calendar.date
      appointments = calendar.appointments
      expect(date).to eq(Date.new(2021, 0o1, 14))
      expect(appointments.size).to eq(2)
      expect(appointments.first.id).to eq(appointment1.id)
      expect(appointments.first.shortened_id.length).to eq(8)
      expect(appointments.first.starting_at).to eq(appointment1.starting_at)
      expect(appointments.first.duration).to eq(appointment1.duration)
      expect(appointments.second.id).to eq(appointment2.id)
      expect(appointments.second.shortened_id.length).to eq(8)
      expect(appointments.second.starting_at).to eq(appointment2.starting_at)
      expect(appointments.second.duration).to eq(appointment2.duration)
    end

    it "returns success with calendar days of week" do
      result = described_class.call(date: date)

      expect(result.success?).to eq(true)
      calendar = result.value!
      days_of_week = calendar.days_of_week
      expect(days_of_week).to eq([
        Date.new(2021, 1, 11),
        Date.new(2021, 1, 12),
        Date.new(2021, 1, 13),
        Date.new(2021, 1, 14),
        Date.new(2021, 1, 15),
        Date.new(2021, 1, 16),
        Date.new(2021, 1, 17)
      ])
    end

    it "returns succes with calendar working hours" do
      result = described_class.call(date: date)

      expect(result.success?).to eq(true)
      calendar = result.value!
      working_hours = calendar.working_hours
      expect(working_hours).to include("07:00")
        .and(include("22:00"))
    end
  end
end
