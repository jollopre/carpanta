require "domain/shared/validation"

module Carpanta
  module Domain
    module Customers
      module Validations
        class OnCreate < Shared::Validation
          EMAIL = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i.freeze

          params do
            required(:name).filled(:string)
            required(:surname).filled(:string)
            required(:email).value(format?: EMAIL)
            optional(:phone).filled(:string)
          end
        end
      end
    end
  end
end
