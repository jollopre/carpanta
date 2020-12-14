require_relative 'base'
require 'domain/shared/date'

module Carpanta
  module Controllers
    class Appointments < Base
      get '/appointments/weekly' do
        haml :'appointments/weekly', locals: { cwdays: ::Domain::Shared::Date.cwdays, hours: ::Domain::Shared::Date.working_hours }
      end
    end
  end
end
