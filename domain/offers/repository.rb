require 'infra/orm'
require_relative 'offer'
require_relative 'errors'

module Carpanta
  module Domain
    module Offers
      class Repository
        PERSISTENCE_KEYS = [:id, :created_at, :updated_at].freeze
        DESERIALIZATION_HANDLERS = {
          tasks: lambda { |value| JSON.parse(value) }
        }
        DESERIALIZATION_HANDLERS.default = lambda { |value| value }
        DESERIALIZATION_HANDLERS.freeze

        class << self
          def save!(offer)
            storage.create!(offer.attributes)
            true
          end

          def find_by_id!(id)
            record = storage.find(id)
            build_from_storage(record)
          rescue ActiveRecord::RecordNotFound
            raise Errors::NotFound
          end

          private

          def storage
            Infra::ORM::Offer
          end

          def build_from_storage(record)
            attrs = record.attributes.symbolize_keys.reject { |k| PERSISTENCE_KEYS.include?(k) }
            deserialized_attrs = attrs.reduce({}) { |acc, (k,v)| acc[k] = DESERIALIZATION_HANDLERS[k].call(v); acc }
            offer = Offer.build(deserialized_attrs)
            offer.send(:id=, record.id)
            offer
          end
        end
      end
    end
  end
end
