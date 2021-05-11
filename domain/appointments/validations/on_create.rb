require "domain/shared/validation"
require "domain/appointments/appointment"

module Carpanta
  module Domain
    module Appointments
      module Validations
        class OnCreate < Shared::Validation
          ZERO = 0

          params do
            required(:duration).filled(:integer, gt?: ZERO, included_in?: Domain::Appointments::Appointment::DURATION_MINUTES)
            required(:starting_at).filled(:time)
            required(:customer_id).filled(:string)
            required(:offer_id).filled(:string)
          end
        end
      end
    end
  end
end
