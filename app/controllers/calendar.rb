require_relative 'base'
require 'app/helpers/calendar_helper'
require 'domain/shared/date'

module Carpanta
  module Controllers
    class Calendar < Base
      get '/calendar/week' do
        haml :'calendar/week/show', locals: { cwdays: ::Domain::Shared::Date.cwdays, hours: ::Domain::Shared::Date.working_hours, helper: Helpers::CalendarHelper.new }
      end
    end
  end
end
