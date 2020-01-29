require 'app/services/tasks/model'
require 'app/services/errors'
require 'app/services/tasks/repository'

module Carpanta
  module Services
    module Tasks
      class << self
        def create!(attributes)
          unpersisted_task = Model.new(attributes)

          raise Errors::RecordInvalid.new(unpersisted_task.errors.full_messages) unless unpersisted_task.valid?
          task = Repository.create(unpersisted_task)

          task
        end
      end
    end
  end
end
