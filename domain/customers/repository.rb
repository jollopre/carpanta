require 'infra/orm'
require 'domain/shared/resultable'
require 'domain/customers/customer'

module Carpanta
  module Domain
    module Customers
      class Repository
        include Domain::Shared::Resultable

        ATTRIBUTE_NAMES = [:id, :name, :surname, :email, :phone].freeze

        def initialize(storage: Infra::ORM::Customer)
          @storage = storage
        end

        def save(customer)
          result = storage.new(customer.to_h).save
          result ? Success() : Failure()
        end

        def exists?(conditions = :none)
          result = storage.exists?(conditions)
          result ? Success() : Failure()
        end

        def find_by_id(id)
          values = storage
            .where(id: id)
            .pluck(*ATTRIBUTE_NAMES)
            .first
          return Failure() unless values.present?

          attributes = ATTRIBUTE_NAMES.zip(values).to_h
          Success(Customer.new(attributes))
        end

        private
        attr_reader :storage
      end
    end
  end
end
