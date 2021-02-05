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
      def_delegator :date, :==
      def_delegator :date, :-
      def_delegator :date, :+

      def initialize(date)
        @date = date
      end

      def days_of_week
        days = Array.new(SEVEN) { self.beginning_of_week }
        _, *rest_of_week = days
        rest_of_week.each_with_index do |_,index|
          days[index + ONE] = days[index].next_day
        end
        days.map{ |date| self.class.new(date) }
      end

      private

      attr_reader :date
    end
  end
end
