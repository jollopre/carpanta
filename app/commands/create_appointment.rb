require 'lib/configurable'
require 'domain/appointments/appointment_legacy'
require 'domain/shared/resultable'
require 'domain/shared/callable'

module Carpanta
  module Commands
    class CreateAppointment
      extend Domain::Shared::Callable
      include Configurable
      include Domain::Shared::Resultable
      configure_with :repository

      def call(params = {})
        appointment = Domain::Appointments::AppointmentLegacy.build(params)

        return Failure(appointment.errors.messages) unless appointment.errors.empty?

        repository.save!(appointment)
        Success(appointment.id)
      end

      private

      def repository
        self.class.configuration.repository
      end
    end
  end
end
