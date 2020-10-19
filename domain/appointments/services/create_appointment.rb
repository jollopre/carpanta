require 'domain/shared/callable'
require 'domain/shared/resultable'
require 'domain/shared/do_notation'
require 'domain/appointments/validations/on_create'
require 'domain/appointments/appointment'
require 'domain/appointments/repository'

module Carpanta
  module Domain
    module Appointments
      module Services
        class CreateAppointment
          extend Shared::Callable
          include Shared::Resultable
          include Shared::DoNotation

          def initialize(repository: Repository.new)
            @repository = repository
          end

          def call(params = {})
            sanitized_params = yield validate(params)
            appointment = Appointment.new(sanitized_params)
            yield create(appointment)

            Success(appointment.id)
          end

          private
          attr_reader :repository

          def validate(params)
            Validations::OnCreate.call(params)
          end

          def create(appointment)
            repository.save(appointment)
          end
        end
      end
    end
  end
end
