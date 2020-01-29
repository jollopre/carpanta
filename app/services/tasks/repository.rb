module Carpanta
  module Services
    module Tasks
      class Repository
        class << self
          def create(task)
            attributes = task.serializable_hash

            result = Storage.create(attributes)
            if result.errors.empty?
              task.id = result.id
              task.created_at = result.created_at
              task.updated_at = result.updated_at
            else
              task.errors.merge!(result.errors)
            end

            task
          end
        end

        class Storage < ActiveRecord::Base
          self.table_name = 'tasks'
        end
      end
    end
  end
end
