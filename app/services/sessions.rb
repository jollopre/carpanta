require 'lib/configurable'
require 'app/services/errors'
require_relative 'sessions/model'

module Carpanta
  module Services
    module Sessions
      include Configurable
      configure_with :repository

      class << self
        def create!(attributes)
          session = Model.new(attributes)

          raise Errors::RecordInvalid.new(session.errors.full_messages) unless session.valid?

          repository.create(session.serializable_hash)

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
