module Carpanta
  module Domain
    module Customers
      module Services
        class CreateCustomer
          class << self
            def call(customer_attributes)
              # Validate against Customer model
              # Deferred Validations (e.g. uniqueness for email)
              # Repository.save(customer)
              # Return a Result (success/failure)
            end
          end
        end
      end
    end
  end
end
