require 'domain/shared/validation'

module Carpanta
  module Domain
    module Offers
      module Validations
        class OnCreate < Shared::Validation
          ZERO = 0.freeze
          params do
            required(:price).filled(:integer, gt?: ZERO)
            required(:tasks).array(:string)
          end
        end
      end
    end
  end
end
