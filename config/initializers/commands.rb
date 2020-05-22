require 'app/commands/create_appointment'

Carpanta::Commands::CreateAppointment.configure do |config|
  require 'domain/appointments/repository'
  config.repository = Carpanta::Domain::Appointments::Repository
end
