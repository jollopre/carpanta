require 'infra/orm'
require_relative 'offer'
require_relative 'errors'

module Carpanta
  module Domain
    module Offers
      class Repository
        PERSISTENCE_KEYS = [:id, :created_at, :updated_at].freeze

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
            offer = Offer.build(attrs)
            offer.send(:id=, record.id)
            offer
          end
        end
      end
    end
  end
end
