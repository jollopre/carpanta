require_relative 'customer'

module Carpanta
  module Domain
    module Customers
      class CustomerRepository
        PERSISTENCE_KEYS = [:id, :created_at, :updated_at].freeze

        class << self
          def create!(customer)
            result = CustomerStorage.create!(customer.attributes)

            with_persistence_attrs(result, customer)

            customer
          end

          def exists?(customer)
            CustomerStorage.exists?(email: customer.email)
          end

          def find_all
            entries = CustomerStorage.all.offset(0).limit(100).order(:id)
            entries.map do |entry|
              attrs = entry.attributes.symbolize_keys.reject{ |k| PERSISTENCE_KEYS.include?(k) }
              customer = Customer.from_params(attrs)
              with_persistence_attrs(entry, customer)
              customer
            end
          end

          private

          def with_persistence_attrs(result, customer)
            PERSISTENCE_KEYS.each do |key|
              value = result.send(key)
              customer.send("#{key}=", value)
            end
          end
        end
      end

      class CustomerStorage < ActiveRecord::Base
        self.table_name = 'customers'
      end
    end
  end
end
