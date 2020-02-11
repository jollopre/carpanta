module Carpanta
  module Services
    module Customers
      class Repository
        class << self
          def create(customer)
            attributes = customer.serializable_hash

            result = Storage.create(attributes)
            if result.errors.empty?
              customer.id = result.id
              customer.created_at = result.created_at
              customer.updated_at = result.updated_at
            else
              customer.errors.merge!(result.errors)
            end

            customer
          end
        end

        class Storage < ActiveRecord::Base
          self.table_name = 'customers'
          validates_uniqueness_of :email
        end
      end
    end
  end
end
