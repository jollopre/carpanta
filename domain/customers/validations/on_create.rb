require 'domain/shared/validation'

module Carpanta
  module Domain
    module Customers
      module Validations
        class OnCreate < Shared::Validation
          #ID = /[0-9a-fA-F]{8}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{12}/.freeze
          EMAIL = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i.freeze

          params do
            #optional(:id).value(format?: ID)
            required(:name).filled(:string)
            required(:surname).filled(:string)
            required(:email).value(format?: EMAIL)
          end
        end
      end
    end
  end
end
