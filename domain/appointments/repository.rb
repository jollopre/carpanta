require 'infra/orm'
require 'domain/shared/resultable'
require 'domain/appointments/appointment'

module Carpanta
  module Domain
    module Appointments
      class Repository
        include Domain::Shared::Resultable

        def initialize(storage: Infra::ORM::Appointment)
          @storage = storage
        end

        def save(appointment)
          result = storage.new(appointment.to_h).save
          result ? Success() : Failure()
        end

        def exists?(conditions = :none)
          result = storage.exists?(conditions)
          result ? Success() : Failure()
        end

        private
        attr_reader :storage
      end
    end
  end
end
