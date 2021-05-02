require "octicons"
require_relative "base"
require "domain/shared/date"
require "app/queries/show_weekly_calendar"
require "app/presenters/weekly_calendar_presenter"
require "app/queries/show_appointment"

module Carpanta
  module Controllers
    class Calendar < Base
      get "/calendar/week/:date" do
        weekly_calendar = Queries::ShowWeeklyCalendar.call(date: params[:date]).value!
        haml :'calendar/week/show', locals: {weekly_calendar_presenter: Presenters::WeeklyCalendarPresenter.new(weekly_calendar)}
      end

      get "/calendar/appointments/:id" do
        result = Queries::ShowAppointment.call(params[:id])

        if result.success?
          haml :'calendar/appointments/show', locals: {appointment: result.value!}, layout: false
        else
          status 404
        end
      end
    end
  end
end
