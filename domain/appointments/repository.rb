require 'infra/orm'
require_relative 'appointment_legacy'

module Carpanta
  module Domain
    module Appointments
      class Repository
        PERSISTENCE_KEYS = [:id, :created_at, :updated_at].freeze

        class << self
          def save!(appointment)
            storage.create!(appointment.attributes)
            true
          end

          def find_all
            records = storage.offset(0).limit(100).order(created_at: :desc)
            records.map do |record|
              build_from_storage(record)
            end
          end

          private

          def storage
            Infra::ORM::Appointment
          end

          def build_from_storage(record)
            attrs = record.attributes.symbolize_keys.reject { |k| PERSISTENCE_KEYS.include?(k) }
            appointment = AppointmentLegacy.build(attrs)
            appointment.send(:id=, record.id)
            appointment
          end
        end
      end
    end
  end
end
