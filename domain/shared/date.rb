require 'date'

module Domain
  module Shared
    module Date
      ZERO = 0.freeze
      ONE = 1.freeze
      FIVE = 5.freeze
      DAYS_OF_WEEK = 7.freeze

      class << self
        def cwdays
          today = ::Date.today
          csunday = today.cwday == ZERO ? today : today + (DAYS_OF_WEEK - today.cwday)
          days = Array.new(DAYS_OF_WEEK, csunday)
          FIVE.downto(ZERO).each do |i|
            days[i] = days[i+ONE].prev_day
          end
          days
        end

        def working_hours
          ['07:00', '08:00', '09:00', '10:00', '11:00', '12:00', '13:00', '14:00', '15:00', '16:00', '17:00', '18:00', '19:00', '20:00', '21:00', '22:00']
        end
      end
    end
  end
end
