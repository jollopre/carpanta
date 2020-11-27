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
      end
    end
  end
end
