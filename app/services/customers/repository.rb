module Carpanta
  module Services
    module Customers
      class Repository
        class << self
          def create(customer)
          end
        end
      end

      class Storage < ActiveRecord::Base
        self.table_name = 'customers'
      end
    end
  end
end
