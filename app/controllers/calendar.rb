require_relative 'base'
require 'app/helpers/calendar_helper'
require 'domain/shared/date'
require 'app/queries/show_appointments_by_starting_at'

module Carpanta
  module Controllers
    class Calendar < Base
      get '/calendar/week' do
        start_time = Time.new(2021,1,11,6,0,0)
        end_time = Time.new(2021,1,17,22,0,0)

        haml :'calendar/week/show', locals: { hours: ::Domain::Shared::Date.working_hours, helper: Helpers::CalendarHelper.new, appointments: Queries::ShowAppointmentsByStartingAt.call(start_time: start_time, end_time: end_time).value! }
      end
    end
  end
end
