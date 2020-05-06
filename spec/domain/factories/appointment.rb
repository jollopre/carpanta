require 'domain/appointments/appointment'

FactoryBot.define do
  factory :appointment, class: Carpanta::Domain::Appointments::Appointment do
    starting_at { Time.new(2020, 05, 06, 8, 25, 12) }
    customer_id { 1 }
    offer_id { 1 }

    initialize_with do
      Carpanta::Domain::Appointments::Appointment.build(attributes)
    end
  end
end
