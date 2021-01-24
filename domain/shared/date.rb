require 'forwardable'

module Domain
  module Shared
    class Date
      extend Forwardable
      ONE = 1.freeze
      SEVEN = 7.freeze

      def_delegator :date, :today?
      def_delegator :date, :beginning_of_week
      def_delegator :date, :end_of_week
      def_delegator :date, :strftime

      class << self
        def working_hours
          ['07:00', '08:00', '09:00', '10:00', '11:00', '12:00', '13:00', '14:00', '15:00', '16:00', '17:00', '18:00', '19:00', '20:00', '21:00', '22:00']
        end
      end

      def initialize(date)
        @date = date
      end

      def days_of_week
        days = Array.new(SEVEN) { self.beginning_of_week }
        _, *rest_of_week = days
        rest_of_week.each_with_index do |_,index|
          days[index + ONE] = days[index].next_day
        end
        days
      end

      private

      attr_reader :date
    end
  end
end
