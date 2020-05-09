require_relative 'customer'
require_relative 'errors'

module Carpanta
  module Domain
    module Customers
      class Repository
        PERSISTENCE_KEYS = [:id, :created_at, :updated_at].freeze

        class << self
          def save!(customer)
            CustomerStorage.create!(customer.attributes)
            true
          end

          def exists?(customer)
            CustomerStorage.exists?(email: customer.email)
          end

          def find_all
            records = CustomerStorage.all.offset(0).limit(100).order(:created_at)
            records.map do |record|
              build_from_storage(record)
            end
          end

          def find_by_id!(id)
            record = CustomerStorage.find(id)
            build_from_storage(record)
          rescue ActiveRecord::RecordNotFound
            raise Errors::NotFound
          end

          private

          def build_from_storage(record)
            attrs = record.attributes.symbolize_keys.reject { |k| PERSISTENCE_KEYS.include?(k) }
            customer = Customer.build(attrs)
            customer.send(:id=, record.id)
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
