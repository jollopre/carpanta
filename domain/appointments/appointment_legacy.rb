require 'domain/shared/entity_legacy'

module Carpanta
  module Domain
    module Appointments
      class AppointmentLegacy < Shared::EntityLegacy
        ZERO = 0.freeze
        attr_reader :starting_at, :duration, :customer_id, :offer_id

        validates_presence_of :starting_at, :customer_id, :offer_id
        validates_numericality_of :duration, only_integer: true, greater_than: ZERO, allow_nil: true

        def attributes
          { id: id, starting_at: starting_at, duration: duration, customer_id: customer_id, offer_id: offer_id }
        end

        private

        def initialize(starting_at: nil, duration: nil, customer_id: nil, offer_id: nil)
          super()
          @starting_at = starting_at
          @duration = duration
          @customer_id = customer_id
          @offer_id = offer_id
        end

        class << self
          def build(starting_at: nil, duration: nil, customer_id: nil, offer_id: nil)
            appointment = new(starting_at: starting_at, duration: duration, customer_id: customer_id, offer_id: offer_id)

            appointment.validate

            appointment
          end
        end
      end
    end
  end
end
