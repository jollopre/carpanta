module Carpanta
  module Helpers
    class CalendarHelper
      ZERO = 0.freeze
      ONE = 1.freeze
      FIVE = 5.freeze
      DAYS_OF_WEEK = 7.freeze
      GRID_COLUMN_TO_WDAY = {
        0 => 9,
        1 => 3,
        2 => 4,
        3 => 5,
        4 => 6,
        5 => 7,
        6 => 8
      }.freeze

      attr_reader :wdays

      def initialize(date = Date.today)
        @wdays = calculate_weekdays_for(date)
      end

      def unique_month_year
        months = wdays.map{ |date| date.strftime('%b') }.uniq
        years = wdays.map{ |date| date.strftime('%Y') }.uniq

        if years.size > 1
          "#{months.first} #{years.first } - #{months.last} #{years.last}"
        elsif months.size > 1
          "#{months.first} - #{months.last} #{years.first}"
        else
          "#{months.first} #{years.first}"
        end
      end

      def today?(date)
        Date.today == date
      end

      def weekday_name_and_day_of_month(date)
        "#{date.strftime('%a')} #{date.strftime('%d')}"
      end

      def grid_area(time:, duration:)
        grid_column = GRID_COLUMN_TO_WDAY.fetch(time.wday)
        grid_row_start = (time.hour + delta_row(time) - 6) * 2 + 1
        grid_row_end = grid_row_start + duration / 30
        "grid-column: #{grid_column}; grid-row-start: #{grid_row_start}; grid-row-end: #{grid_row_end};"
      end

      private

      def delta_row(time)
        time.min == 0 ? 0 : 1
      end

      def calculate_weekdays_for(date)
        csunday = date.cwday == ZERO ? date : date + (DAYS_OF_WEEK - date.cwday)
        days = Array.new(DAYS_OF_WEEK, csunday)
        FIVE.downto(ZERO).each do |i|
          days[i] = days[i+ONE].prev_day
        end
        days
      end
    end
  end
end
