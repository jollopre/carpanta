module Carpanta
  module Domain
    module Shared
      class Entity
        include ActiveModel::Model
        include ActiveModel::Serialization

        attr_accessor :id, :created_at, :updated_at

        def attributes
          { id: id, created_at: created_at, updated_at: updated_at }
        end

        def ==(entity)
          return false unless entity.respond_to?(:attributes)

          attributes == entity.attributes
        end
      end
    end
  end
end
