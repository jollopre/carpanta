require 'lib/configurable'
require 'app/services/errors'
require_relative 'tasks/model'

module Carpanta
  module Services
    module Tasks
      include Configurable
      configure_with :repository

      class << self
        def create!(attributes)
          task = Model.new(attributes)

          raise Errors::RecordInvalid.new(task.errors.full_messages) unless task.valid?

          repository.create(task.serializable_hash)

          true
        end

        private

        def repository
          configuration.repository
        end
      end
    end
  end
end
