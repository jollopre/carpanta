module Carpanta
  module Repositories
    class Task
      class << self
        def create!(task)
          result = Storage.create!(task.serializable_hash)

          task.id = result.id
          task.created_at = result.created_at
          task.updated_at = result.updated_at
          task
        end
      end

      class Storage < ActiveRecord::Base
        self.table_name = 'tasks'
      end
    end
  end
end
