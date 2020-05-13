require 'lib/configurable'
require 'domain/appointments/appointment'
require 'domain/customers/errors'
require 'domain/offers/errors'

module Carpanta
  module Services
    class CreateAppointment
      include Configurable
      configure_with :repository, :customer_repository, :offer_repository

      class << self
        def call(attributes)
          appointment = Domain::Appointments::Appointment.build(attributes)
          appointment.errors.add(:customer_id, :not_found) unless customer_exists?(appointment.customer_id)
          appointment.errors.add(:offer_id, :not_found) unless offer_exists?(appointment.offer_id)

          repository.save!(appointment) if appointment.errors.empty?

          appointment
        end

        private

        def repository
          configuration.repository
        end

        def customer_repository
          configuration.customer_repository
        end

        def offer_repository
          configuration.offer_repository
        end

        def customer_exists?(customer_id)
          customer_repository.find_by_id!(customer_id)
          true
        rescue Domain::Customers::Errors::NotFound
          false
        end

        def offer_exists?(offer_id)
          offer_repository.find_by_id!(offer_id)
          true
        rescue Domain::Offers::Errors::NotFound
          false
        end
      end
    end
  end
end
