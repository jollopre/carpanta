require 'domain/customers/validations/on_create'
require 'domain/shared/callable'
require 'domain/shared/resultable'
require 'domain/shared/do_notation'

module Carpanta
  module Commands
    class CreateCustomer
      extend Domain::Shared::Callable
      include Domain::Shared::Resultable
      include Domain::Shared::DoNotation

      def call(params = {})
        yield validate(params)

        Success('an_id')
      end

      private

      def validate(params)
        Domain::Customers::Validations::OnCreate.call(params)
      end
    end
  end
end
