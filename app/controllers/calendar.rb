require_relative 'base'
require 'app/helpers/calendar_helper'
require 'domain/shared/date'
require 'app/queries/show_appointments_by_week'

module Carpanta
  module Controllers
    class Calendar < Base
      get '/calendar/week/:date' do
        haml :'calendar/week/show', locals: { hours: ::Domain::Shared::Date.working_hours, helper: Helpers::CalendarHelper.new(Date.new(2021,1,21)), appointments: Queries::ShowAppointmentsByWeek.call(date: params[:date]).value! }
      end
    end
  end
end
