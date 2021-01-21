require 'infra/orm'
require 'domain/shared/callable'
require 'domain/shared/resultable'
require 'domain/shared/validation'
require 'domain/shared/do_notation'
require 'domain/shared/date'

module Carpanta
  module Queries
    class ShowAppointmentsByWeek
      extend Domain::Shared::Callable
      include Domain::Shared::Resultable
      include Domain::Shared::DoNotation

      def initialize(relation: Infra::ORM::Appointment.all)
        @relation = relation
      end

      def call(params = {})
        result = yield Contract.call(params)

        date = ::Domain::Shared::Date.new(result.fetch(:date))

        collection = relation
          .where(starting_at: beginning_of_week(date)..end_of_week(date))
          .pluck(:id, :starting_at, :duration)
        appointments = collection.map do |item|
          Appointment.new(id: item[0], starting_at: item[1], duration: item[2])
        end

        Success(appointments)
      end

      private

      def beginning_of_week(date)
        monday = date.beginning_of_week
        Time.new(monday.year, monday.month, monday.day,6,0,0)
      end

      def end_of_week(date)
        sunday = date.end_of_week
        Time.new(sunday.year, sunday.month, sunday.day,22,0,0)
      end

      attr_reader :relation

      class Contract < Domain::Shared::Validation
        params do
          required(:date).filled(:date)
        end
      end

      class Appointment
        attr_reader :id, :starting_at, :duration

        def initialize(args)
          @id, @starting_at, @duration = args.values_at(:id, :starting_at, :duration)
        end
      end
    end
  end
end
