require "forwardable"
require "infra/orm"
require "domain/shared/callable"
require "domain/shared/resultable"

module Carpanta
  module Queries
    class ShowAppointment
      extend Domain::Shared::Callable
      include Domain::Shared::Resultable

      def initialize(relation: Infra::ORM::Appointment.all)
        @relation = relation
      end

      def call(id)
        appointment = relation.where(id: id).joins(:offer, :customer).includes(:offer, :customer).first
        return Failure(id: :not_found) unless appointment

        Success(Appointment.new(appointment))
      end

      private

      attr_reader :relation

      class Appointment
        extend Forwardable

        def_delegators :@appointment, :id, :starting_at, :duration

        def initialize(appointment)
          @appointment = appointment
        end

        def shortened_id
          id[0, 8]
        end

        def offer
          @offer ||= Offer.new(@appointment.offer)
        end

        def customer
          @customer ||= Customer.new(@appointment.customer)
        end
      end

      class Offer
        def initialize(offer)
          @offer = offer
        end

        def name
          @offer.tasks.to_sentence
        end
      end

      class Customer
        extend Forwardable

        def_delegators :@customer, :id, :name, :surname, :email, :phone

        def initialize(customer)
          @customer = customer
        end
      end
    end
  end
end
