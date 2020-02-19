module Carpanta
  module Repositories
    class Session
      class << self
        def create!(session)
          result = Storage.create!(session.serializable_hash)

          session.id = result.id
          session.created_at = result.created_at
          session.updated_at = result.updated_at
          session
        end
      end

      class Storage < ActiveRecord::Base
        self.table_name = 'sessions'
      end
    end
  end
end
