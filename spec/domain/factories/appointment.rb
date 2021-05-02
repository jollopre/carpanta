require "domain/appointments/appointment"
require "domain/appointments/repository"

FactoryBot.define do
  factory :appointment, class: Carpanta::Domain::Appointments::Appointment do
    starting_at { Time.new(2020, 0o5, 0o6, 8, 25, 12) }
    duration { 30 }
    customer_id { build(:customer).id }
    offer_id { build(:offer).id }

    initialize_with do
      Carpanta::Domain::Appointments::Appointment.new(attributes)
    end

    to_create do |instance|
      repository = Carpanta::Domain::Appointments::Repository.new
      repository.save(instance).value!
    end
  end
end
