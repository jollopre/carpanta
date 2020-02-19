require 'lib/configurable'
require 'app/services/errors'
require 'app/entities/task'

module Carpanta
  module Services
    module Tasks
      include Configurable
      configure_with :repository

      class << self
        def create!(attributes)
          task = Entities::Task.new(attributes)

          raise Errors::RecordInvalid.new(task.errors.full_messages) unless task.valid?

          repository.create!(task)
        end

        private

        def repository
          configuration.repository
        end
      end
    end
  end
end
