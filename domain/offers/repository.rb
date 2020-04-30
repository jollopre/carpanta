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
          def create!(offer)
            result = OfferStorage.create!(offer.attributes)

            with_persistence_attrs(result, offer)

            offer
          end

          def find_by_id!(id)
            record = OfferStorage.find(id)
            build_from_storage(record)
          rescue ActiveRecord::RecordNotFound
            raise Errors::NotFound
          end

          private

          def with_persistence_attrs(record, offer)
            PERSISTENCE_KEYS.each do |key|
              value = record.send(key)
              offer.send("#{key}=", value)
            end
          end

          def build_from_storage(record)
            attrs = record.attributes.symbolize_keys.reject { |k| PERSISTENCE_KEYS.include?(k) }
            deserialized_attrs = attrs.reduce({}) { |acc, (k,v)| acc[k] = DESERIALIZATION_HANDLERS[k].call(v); acc }
            offer = Offer.build(deserialized_attrs)
            with_persistence_attrs(record, offer)
            offer
          end
        end
      end

      class OfferStorage < ActiveRecord::Base
        self.table_name = 'offers'
      end
    end
  end
end
