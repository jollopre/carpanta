require 'app/helpers/calendar_helper'

RSpec.describe Carpanta::Helpers::CalendarHelper do
  subject{ described_class.new }

  describe '#unique_month_year' do
    let(:dates) { [Date.new(2020,12,17)] }

    it 'displays unique abbreviated month name and year with century for the collection of dates' do
      result = subject.unique_month_year(dates)

      expect(result).to eq('Dec 2020')
    end

    context 'when there are dates from different months' do
      let(:dates) do
        [
          Date.new(2020,11,30),
          Date.new(2020,12,1)
        ]
      end

      it 'displays unique abbreviated month name and year with century for the collection of dates' do
        result = subject.unique_month_year(dates)

        expect(result).to eq('Nov - Dec 2020')
      end
    end

    context 'when there are dates from different years' do
      let(:dates) do
        [
          Date.new(2020,12,31),
          Date.new(2021,1,1)
        ]
      end

      it 'displays unique abbreviated month name and year with century for the collection of dates' do
        result = subject.unique_month_year(dates)

        expect(result).to eq('Dec 2020 - Jan 2021')
      end
    end
  end

  describe '#today?' do
    let(:date) { Date.new(2020,12,20) }

    context 'when date passed is today' do
      let(:date) { Date.today }
      it 'returns true' do
        result = subject.today?(date)

        expect(result).to eq(true)
      end
    end

    it 'returns false otherwise' do
      result = subject.today?(date)

      expect(result).to eq(false)
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
end
