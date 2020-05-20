require 'forwardable'
require 'infra/orm'

module Carpanta
  module Queries
    class ShowCustomer

      attr_reader :relation

      def initialize(relation = Infra::ORM::Customer.all)
        @relation = relation
      end

      def call(id)
        customer = relation.where(id: id).includes(:appointments).first
        Customer.new(customer)
      end

      class Customer
        extend Forwardable

        def_delegators :@customer, :id, :name, :surname, :email, :phone
        attr_reader :appointments

        def initialize(customer)
          @customer = customer
          @appointments = customer.appointments.map do |appointment|
            Appointment.new(appointment)
          end
        end
      end

      class Appointment
        extend Forwardable

        def_delegators :@appointment, :starting_at, :duration

        def initialize(appointment)
          @appointment = appointment
        end

        def offer
          @offer ||= Offer.new(@appointment.offer)
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
    end
  end
end
