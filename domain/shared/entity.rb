require_relative 'custom_validators'

module Carpanta
  module Domain
    module Shared
      class Entity
        TIMESTAMPS = [:created_at, :updated_at].freeze

        include ActiveModel::Model
        include ActiveModel::Serialization
        extend Shared::CustomValidators

        attr_accessor :id, :created_at, :updated_at

        def attributes
          { id: id, created_at: created_at, updated_at: updated_at }
        end

        def ==(entity)
          return false unless entity.is_a?(Entity)

          attrs = exclude_timestamps(attributes)
          entity_attrs = exclude_timestamps(entity.attributes)

          attrs == entity_attrs
        end

        private

        def exclude_timestamps(attributes)
          attributes.reject{ |k,_| TIMESTAMPS.include?(k) }
        end
      end
    end
  end
end
