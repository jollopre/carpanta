module Carpanta
  module Repositories
    module Base
      def create!(entity)
        result = storage.create!(entity.serializable_hash)

        entity.id = result.id
        entity.created_at = result.created_at
        entity.updated_at = result.updated_at
        entity
      rescue ActiveRecord::RecordInvalid => e
        raise RecordInvalid.new(e.message)
      end

      def storage
        configuration.storage
      end
    end

    class RecordInvalid < StandardError ; end
  end
end
