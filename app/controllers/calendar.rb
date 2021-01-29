require_relative 'base'
require 'domain/shared/date'
require 'app/queries/show_weekly_calendar'
require 'app/presenters/weekly_calendar_presenter'

module Carpanta
  module Controllers
    class Calendar < Base
      get '/calendar/week/:date' do
        weekly_calendar = Queries::ShowWeeklyCalendar.call(date: params[:date]).value!
        haml :'calendar/week/show', locals: { weekly_calendar_presenter: Presenters::WeeklyCalendarPresenter.new(weekly_calendar) }
      end
    end
  end
end
