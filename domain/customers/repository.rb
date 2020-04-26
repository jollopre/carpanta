require_relative 'customer'
require_relative 'errors'

module Carpanta
  module Domain
    module Customers
      class Repository
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
            records = CustomerStorage.all.offset(0).limit(100).order(:id)
            records.map do |record|
              build_from_storage(record)
            end
          end

          def find_by_id(id)
            record = CustomerStorage.find(id)
            build_from_storage(record)
          rescue ActiveRecord::RecordNotFound
            raise Errors::NotFound
          end

          private

          def with_persistence_attrs(record, customer)
            PERSISTENCE_KEYS.each do |key|
              value = record.send(key)
              customer.send("#{key}=", value)
            end
          end

          def build_from_storage(record)
            attrs = record.attributes.symbolize_keys.reject { |k| PERSISTENCE_KEYS.include?(k) }
            customer = Customer.build(attrs)
            with_persistence_attrs(record, customer)
            customer
          end
        end
      end

      class CustomerStorage < ActiveRecord::Base
        self.table_name = 'customers'
      end
    end
  end
end
