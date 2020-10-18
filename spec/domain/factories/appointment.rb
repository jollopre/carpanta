require 'domain/appointments/appointment'
require 'domain/appointments/appointment_legacy'
require 'domain/appointments/repository_legacy'

FactoryBot.define do
  factory :appointment_legacy, class: Carpanta::Domain::Appointments::AppointmentLegacy do
    starting_at { Time.new(2020, 05, 06, 8, 25, 12) }
    customer_id { build(:customer).id }
    offer_id { build(:offer).id }

    initialize_with do
      Carpanta::Domain::Appointments::AppointmentLegacy.build(attributes)
    end

    to_create do |instance|
      Carpanta::Domain::Appointments::RepositoryLegacy.save!(instance)
    end
  end

  factory :appointment, class: Carpanta::Domain::Appointments::Appointment do
    starting_at { Time.new(2020, 05, 06, 8, 25, 12) }
    customer_id { build(:customer).id }
    offer_id { build(:offer).id }

    initialize_with do
      Carpanta::Domain::Appointments::Appointment.new(attributes)
    end
  end
end
