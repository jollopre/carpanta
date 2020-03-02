module Carpanta
  module Repositories
    module Repository
      def create!(entity)
        attributes = entity.serializable_hash

        result = super(attributes)

        entity.id = result.id
        entity.created_at = result.created_at
        entity.updated_at = result.updated_at
        entity
      rescue ActiveRecord::RecordInvalid => e
        raise RecordInvalid.new(e.message)
      end
    end

    class RecordInvalid < StandardError ; end
  end
end
