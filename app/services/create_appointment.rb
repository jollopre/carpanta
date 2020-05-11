require 'domain/appointments/appointment'
require 'lib/configurable'

module Carpanta
  module Services
    class CreateAppointment
      include Configurable
      configure_with :repository

      class << self
        def call(attributes)
          appointment = Domain::Appointments::Appointment.build(attributes)
          repository.save!(appointment)

          appointment
        end

        private

        def repository
          configuration.repository
        end
      end
    end
  end
end
