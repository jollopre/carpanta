require 'app/commands/create_appointment'

Carpanta::Commands::CreateAppointment.configure do |config|
  require 'domain/appointments/repository_legacy'
  config.repository = Carpanta::Domain::Appointments::RepositoryLegacy
end
