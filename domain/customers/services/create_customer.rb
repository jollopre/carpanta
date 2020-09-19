module Carpanta
  module Domain
    module Customers
      module Services
        class CreateCustomer
          class << self
            def call(customer_attributes)
              #result = yield Customers::Customer.create(customer_attributes)
              #customer = result.value!
              #yield Repository.exists?(email: customer.email)
              #yield Repository.save(customer)
            end
          end
        end
      end
    end
  end
end
