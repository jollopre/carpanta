require_relative 'appointment'

module Carpanta
  module Domain
    module Appointments
      class Repository
        PERSISTENCE_KEYS = [:id, :created_at, :updated_at].freeze

        class << self
          def save!(appointment)
            AppointmentStorage.create!(appointment.attributes)
            true
          end

          def find_all
            records = AppointmentStorage.offset(0).limit(100).order(created_at: :desc)
            records.map do |record|
              build_from_storage(record)
            end
          end

          private

          def build_from_storage(record)
            attrs = record.attributes.symbolize_keys.reject { |k| PERSISTENCE_KEYS.include?(k) }
            appointment = Appointment.build(attrs)
            appointment.send(:id=, record.id)
            appointment
          end
        end
      end

      class AppointmentStorage < ActiveRecord::Base
        self.table_name = 'appointments'
      end
    end
  end
end
