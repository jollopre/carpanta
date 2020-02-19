module Carpanta
  module Repositories
    module Base
      def create!(entity)
        result = storage.create!(entity.serializable_hash)

        entity.id = result.id
        entity.created_at = result.created_at
        entity.updated_at = result.updated_at
        entity
      end

      def storage
        configuration.storage
      end
    end
  end
end
