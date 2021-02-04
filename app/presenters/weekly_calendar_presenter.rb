module Carpanta
  module Presenters
    class WeeklyCalendarPresenter < SimpleDelegator
      GRID_COLUMN_TO_WDAY = {
        0 => 9,
        1 => 3,
        2 => 4,
        3 => 5,
        4 => 6,
        5 => 7,
        6 => 8
      }.freeze

      def unique_month_year
        months = days_of_week.map{ |date| date.strftime('%b') }.uniq
        years = days_of_week.map{ |date| date.strftime('%Y') }.uniq

        if years.size > 1
          "#{months.first} #{years.first } - #{months.last} #{years.last}"
        elsif months.size > 1
          "#{months.first} - #{months.last} #{years.first}"
        else
          "#{months.first} #{years.first}"
        end
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

      def grid_area_for_current_time_in_week
        grid_area(time: current_time, duration: 0)
      end

      def today_link
        "/calendar/week/#{format_date(current_time)}"
      end

      def previous_link
        previous_date = date - 7
        "/calendar/week/#{format_date(previous_date)}"
      end

      def next_link
        next_date = date + 7
        "/calendar/week/#{format_date(next_date)}"
      end

      def current_time_in_week?
        current_date = Date.new(current_time.year, current_time.month, current_time.day)
        days_of_week.include?(current_date)
      end

      private

      def delta_row(time)
        time.min == 0 ? 0 : 1
      end

      def format_date(date)
        date.strftime('%Y-%m-%d')
      end

      def current_time
        @current_time ||= Time.now
      end
    end
  end
end
