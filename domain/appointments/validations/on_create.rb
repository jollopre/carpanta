require 'domain/shared/validation'

module Carpanta
  module Domain
    module Appointments
      module Validations
        class OnCreate < Shared::Validation
          ZERO = 0.freeze

          params do
            optional(:duration).filled(:integer, gt?: ZERO)
            required(:starting_at).filled(:date_time)
            required(:customer_id).filled(:string)
            required(:offer_id).filled(:string)
          end
        end
      end
    end
  end
end
