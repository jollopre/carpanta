require 'lib/configurable'
require 'app/services/errors'
require_relative 'customers/model'

module Carpanta
  module Services
    module Customers
      include Configurable
      configure_with :repository

      class << self
        def create!(attributes)
          customer = Model.new(attributes)
          raise Errors::RecordInvalid.new(customer.errors.full_messages) unless customer.valid?

          customer = repository.create(customer.serializable_hash)
          raise Errors::RecordInvalid.new(customer.errors.full_messages) unless customer.valid?

          true
        end

        private

        def repository
          configuration.repository
        end
      end
    end
  end
end
