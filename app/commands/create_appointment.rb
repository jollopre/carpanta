require 'domain/shared/callable'
require 'domain/appointments/services/create_appointment'

module Carpanta
  module Commands
    class CreateAppointment
      extend Domain::Shared::Callable

      def call(params = {})
        Domain::Appointments::Services::CreateAppointment.call(params)
      end
    end
  end
end
