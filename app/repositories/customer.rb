module Carpanta
  module Repositories
    class Customer
      class << self
        def create!(customer)
          result = Storage.create!(customer.serializable_hash)

          customer.id = result.id
          customer.created_at = result.created_at
          customer.updated_at = result.updated_at
          customer
        end
      end

      class Storage < ActiveRecord::Base
        self.table_name = 'customers'
        #validates_uniqueness_of :email
      end
    end
  end
end
