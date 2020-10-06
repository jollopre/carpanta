require 'infra/orm'
require 'domain/shared/resultable'
require 'domain/customers/customer'

module Carpanta
  module Domain
    module Customers
      class Repository
        ATTRIBUTE_NAMES = [:id, :name, :surname, :email, :phone].freeze

        class << self
          include Domain::Shared::Resultable

          def save(customer)
            result = Infra::ORM::Customer
              .new(customer.to_h)
              .save
            result ? Success() : Failure()
          end

          def exists?(conditions = :none)
            result = Infra::ORM::Customer.exists?(conditions)
            result ? Success() : Failure()
          end

          def find_by_id(id)
            values = Infra::ORM::Customer
              .where(id: id)
              .pluck(ATTRIBUTE_NAMES)
              .first
            return Failure() unless values.present?

            attributes = ATTRIBUTE_NAMES.zip(values).to_h
            Success(Customer.new(attributes))
          end
        end
      end
    end
  end
end
