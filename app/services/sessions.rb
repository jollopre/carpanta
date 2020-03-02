require 'lib/configurable'
require 'app/services/errors'
require 'app/entities/session'

module Carpanta
  module Services
    module Sessions
      include Configurable
      configure_with :repository

      class << self
        def create!(attributes)
          session = Entities::Session.new(attributes)

          raise Errors::RecordInvalid.new(session.errors.full_messages) unless session.valid?

          repository.create!(session)
        end

        private

        def repository
          configuration.repository
        end
      end
    end
  end
end
