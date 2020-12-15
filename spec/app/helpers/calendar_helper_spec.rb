require 'app/helpers/calendar_helper'

RSpec.describe Carpanta::Helpers::CalendarHelper do
  subject{ described_class.new }

  describe '#unique_month_year' do
    it 'displays unique abbreviated month name and year with century for the collection of dates' do
      pending
    end
  end

  describe '#today?' do
    context 'when date passed is today' do
      it 'returns true' do
        pending
      end
    end

    it 'returns false otherwise' do
      pending
    end
  end

  describe '#weekday_name_and_day_of_month' do
    it 'displays abbreviated weekday name followed by day of the month' do
      pending
    end
  end
end
