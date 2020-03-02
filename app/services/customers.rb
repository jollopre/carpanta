require 'lib/configurable'
require 'app/services/errors'
require 'app/entities/customer'

module Carpanta
  module Services
    module Customers
      include Configurable
      configure_with :repository

      class << self
        def create!(attributes)
          customer = Entities::Customer.new(attributes)

          raise Errors::RecordInvalid.new(customer.errors.full_messages) unless customer.valid?

          repository.create!(customer)
        rescue Repositories::RecordInvalid => e
          raise Services::Errors::RecordInvalid.new(e)
        end

        private

        def repository
          configuration.repository
        end
      end
    end
  end
end
