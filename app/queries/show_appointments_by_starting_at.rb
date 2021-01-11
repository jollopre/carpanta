require 'infra/orm'
require 'domain/shared/callable'
require 'domain/shared/resultable'

module Carpanta
  module Queries
    class ShowAppointmentsByStartingAt
      extend Domain::Shared::Callable
      include Domain::Shared::Resultable

      def initialize(relation: Infra::ORM::Appointment.all)
        @relation = relation
      end

      def call(start_time:, end_time:)
        collection = relation.where(starting_at: start_time..end_time).pluck(:id, :starting_at, :duration)
        appointments = collection.map do |item|
          Appointment.new(id: item[0], starting_at: item[1], duration: item[2])
        end
        Success(appointments)
      end

      private

      attr_reader :relation

      class Appointment
        attr_reader :id, :starting_at, :duration

        def initialize(args)
          @id, @starting_at, @duration = args.values_at(:id, :starting_at, :duration)
        end
      end
    end
  end
end
