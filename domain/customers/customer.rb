require 'domain/shared/entity'

module Carpanta
  module Domain
    module Customers
      class Customer < Shared::Entity
        EMAIL_REGEX = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i.freeze

        attr_reader :name, :surname, :email, :phone

        validates_presence_of :name, :surname
        validates :email, format: { with: EMAIL_REGEX }

        def attributes
          super.merge({ name: name, surname: surname, email: email, phone: phone })
        end

        private

        def initialize(name: nil, surname: nil, email: nil, phone: nil)
          @name = name
          @surname = surname
          @email = email
          @phone = phone
        end

        class << self
          def from_params(name: nil, surname: nil, email: nil, phone: nil)
            customer = new(name: name, surname: surname, email: email, phone: phone)

            customer.validate

            customer
          end
        end
      end
    end
  end
end
