require 'infra/orm'
require_relative 'customer_legacy'
require_relative 'errors'

module Carpanta
  module Domain
    module Customers
      class RepositoryLegacy
        PERSISTENCE_KEYS = [:id, :created_at, :updated_at].freeze

        class << self
          def save!(customer)
            storage.create!(customer.attributes)
            true
          end

          def exists?(customer)
            storage.exists?(email: customer.email)
          end

          def find_by_id!(id)
            record = storage.find(id)
            build_from_storage(record)
          rescue ActiveRecord::RecordNotFound
            raise Errors::NotFound
          end

          private

          def storage
            Infra::ORM::Customer
          end

          def build_from_storage(record)
            attrs = record.attributes.symbolize_keys.reject { |k| PERSISTENCE_KEYS.include?(k) }
            customer = CustomerLegacy.build(attrs)
            customer.send(:id=, record.id)
            customer
          end
        end
      end
    end
  end
end
