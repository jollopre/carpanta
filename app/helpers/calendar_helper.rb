module Carpanta
  module Helpers
    class CalendarHelper
      def unique_month_year(weekly_dates)
        months = weekly_dates.map{ |date| date.strftime('%b') }.uniq
        years = weekly_dates.map{ |date| date.strftime('%Y') }.uniq

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
    end
  end
end
