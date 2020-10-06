require 'domain/shared/callable'
require 'domain/shared/resultable'
require 'domain/shared/do_notation'
require_relative 'validations/on_create'
require_relative 'customer'
require_relative 'repository'

module Carpanta
  module Domain
    module Customers
      class CreateCustomerService
        extend Shared::Callable
        include Shared::Resultable
        include Shared::DoNotation

        def call(params = {})
          sanitized_params = yield validate(params)
          customer = Customer.new(sanitized_params)
          yield check_uniqueness_for_email(customer)
          yield create(customer)

          Success(customer.id)
        end

        private

        def validate(params)
          Validations::OnCreate.call(params)
        end

        def create(customer)
          Repository.save(customer)
        end

        def check_uniqueness_for_email(customer)
          result = Repository.exists?(email: customer.email)

          return Failure(email: 'is not unique') if result.success?
          Success()
        end
      end
    end
  end
end
