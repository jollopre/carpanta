require 'date'

module Domain
  module Shared
    class Date < SimpleDelegator
      WDAYS = {
        monday: 1
      }.freeze
      DAYS_OF_WEEK = 7.freeze
      END_WDAYS = 6.freeze

      class << self
        def working_hours
          ['07:00', '08:00', '09:00', '10:00', '11:00', '12:00', '13:00', '14:00', '15:00', '16:00', '17:00', '18:00', '19:00', '20:00', '21:00', '22:00']
        end
      end

      def beginning_of_week
        days = days_to_week_start
        self - days
      end

      def end_of_week
        days = END_WDAYS - days_to_week_start
        self + days
      end

      private

      def days_to_week_start(start_day = :monday)
        (wday - WDAYS.fetch(start_day)) % DAYS_OF_WEEK
      end
    end
  end
end
