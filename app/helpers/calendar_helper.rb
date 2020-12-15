module Carpanta
  module Helpers
    class CalendarHelper
      def unique_month_year(dates)
        dates.map{ |date| "#{date.strftime('%b')} #{date.strftime('%Y')}" }.uniq.join(' - ')
      end

      def today?(date)
        Date.today == date
      end

      def weekday_name_and_day_of_month(date)
        "#{date.strftime('%a')} #{date.strftime('%d')}"
      end
    end
  end
end
