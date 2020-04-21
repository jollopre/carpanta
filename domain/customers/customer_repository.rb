module Carpanta
  module Domain
    module Customers
      class CustomerRepository
        class CustomerStorage < ActiveRecord::Base
          self.table_name = 'customers'
        end

        class << self
          def create!(customer)
            result = CustomerStorage.create!(customer.attributes)

            customer.id = result.id
            customer.created_at = result.created_at
            customer.updated_at = result.updated_at

            customer
          end
        end
      end
    end
  end
end
