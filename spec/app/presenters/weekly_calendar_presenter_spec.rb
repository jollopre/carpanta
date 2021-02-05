require 'app/presenters/weekly_calendar_presenter'
require 'app/queries/show_weekly_calendar'

RSpec.describe Carpanta::Presenters::WeeklyCalendarPresenter do
  let(:date) { Date.new(2021,1,28) }
  let(:weekly_calendar) do
    Carpanta::Queries::ShowWeeklyCalendar::WeeklyCalendar.new(
      date: Domain::Shared::Date.new(date),
      appointments: []
    )
  end
  subject { described_class.new(weekly_calendar) }

  describe '#days_of_week' do
    it 'responds to days_of_week' do
      expect(subject).to respond_to(:days_of_week)
    end
  end

  describe '#unique_month_year' do
    let(:date) { Date.new(2020,12,17) }

    it 'displays unique abbreviated month name and year with century for the collection of dates' do
      result = subject.unique_month_year

      expect(result).to eq('Dec 2020')
    end

    context 'when there are dates from different months' do
      let(:date) { Date.new(2020,11,30) }

      it 'displays unique abbreviated month name and year with century for the collection of dates' do
        result = subject.unique_month_year

        expect(result).to eq('Nov - Dec 2020')
      end
    end

    context 'when there are dates from different years' do
      let(:date) { Date.new(2020,12,31) }

      it 'displays unique abbreviated month name and year with century for the collection of dates' do
        result = subject.unique_month_year

        expect(result).to eq('Dec 2020 - Jan 2021')
      end
    end
  end

  describe '#weekday_name_and_day_of_month' do
    let(:date) { Date.new(2020,12,21) }

    it 'displays abbreviated weekday name followed by day of the month' do
      result = subject.weekday_name_and_day_of_month(date)

      expect(result).to eq('Mon 21')
    end
  end

  describe '#grid_area' do
    let(:time) { Time.new(2020,12,28,17,0,0) }
    let(:duration) { 30 }
    it 'returns grid column, grid row start and grid row end' do
      result = subject.grid_area(time: time, duration: 30)

      expect(result).to eq("grid-column: 3; grid-row-start: 23; grid-row-end: 24;")
    end
  end

  describe '#today_link' do
    let(:date) { Date.new(2020,12,28) }
    before do
      allow(Time).to receive(:now).and_return(Time.new(2021,2,3,8,10,0))
    end

    it "returns a link to the weekly calendar for today's date" do
      result = subject.today_link

      expect(result).to eq('/calendar/week/2021-02-03')
    end
  end

  describe '#previous_link' do
    let(:date) { Date.new(2020,12,28) }

    it 'returns a link to the weekly calendar for the previous week of a date' do
      result = subject.previous_link

      expect(result).to eq('/calendar/week/2020-12-21')
    end
  end

  describe '#next_link' do
    let(:date) { Date.new(2020,12,28) }

    it 'returns a link to the weekly calendar for the next week of a date' do
      result = subject.next_link

      expect(result).to eq('/calendar/week/2021-01-04')
    end
  end

  describe '#current_time_in_week?' do
    let(:date) { Date.new(2020,12,28) }

    it 'returns true' do
      allow(Time).to receive(:now).and_return(Time.new(2020,12,28,8,25,0))

      result = subject.current_time_in_week?

      expect(result).to eq(true)
    end

    it 'returns false' do
      result = subject.current_time_in_week?

      expect(result).to eq(false)
    end
  end

  describe '#grid_area_for_current_time_in_week' do
    it 'returns grid column, grid row start and grid row end' do
      allow(Time).to receive(:now).and_return(Time.new(2021,2,4,8,40,0))

      result = subject.grid_area_for_current_time_in_week

      expect(result).to eq("grid-column: 6; grid-row-start: 7; grid-row-end: 7;")
    end
  end
end
