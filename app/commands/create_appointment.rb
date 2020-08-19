require 'lib/configurable'
require 'domain/appointments/appointment'
require 'domain/shared/result'

module Carpanta
  module Commands
    class CreateAppointment
      include Configurable
      extend Domain::Shared::Result
      configure_with :repository

      class << self
        def call(attributes)
          appointment = Domain::Appointments::Appointment.build(attributes)

          return failure(appointment.errors.messages) unless appointment.errors.empty?

          repository.save!(appointment)
          success(appointment.id)
        end

        private

        def repository
          configuration.repository
        end
      end
    end
  end
end
