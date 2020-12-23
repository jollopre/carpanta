require 'domain/shared/validation'

module Carpanta
  module Domain
    module Appointments
      module Validations
        class OnCreate < Shared::Validation
          ZERO = 0.freeze

          params do
            required(:duration).filled(:integer, gt?: ZERO)
            required(:starting_at).filled(:time)
            required(:customer_id).filled(:string)
            required(:offer_id).filled(:string)
          end
        end
      end
    end
  end
end
