module Carpanta
  module Domain
    module Customers
      class CustomerRepository
        class CustomerStorage < ActiveRecord::Base
          self.table_name = 'customers'
        end

        class << self
          def create!(customer)
            serialized = serialize(customer) 

            result = CustomerStorage.create!(serialized)
            customer.id = result.id
            customer.created_at = result.created_at
            customer.updated_at = result.updated_at

            customer
          end

          private

          def serialize(customer)
            customer.serializable_hash
          end
        end
      end
    end
  end
end
