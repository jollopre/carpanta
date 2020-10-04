require 'domain/appointments/appointment'
require 'domain/appointments/repository'

FactoryBot.define do
  factory :appointment, class: Carpanta::Domain::Appointments::Appointment do
    starting_at { Time.new(2020, 05, 06, 8, 25, 12) }
    customer_id { build(:customer_legacy).id }
    offer_id { build(:offer).id }

    initialize_with do
      Carpanta::Domain::Appointments::Appointment.build(attributes)
    end

    to_create do |instance|
      Carpanta::Domain::Appointments::Repository.save!(instance)
    end
  end
end
