require_relative 'base'
require 'app/entities/session'
require 'app/queries/find_tasks'
require 'app/queries/find_customers'
require 'app/actions/errors'
require 'app/services/sessions'
require 'app/services/errors'

module Carpanta
  module Controllers
    class Sessions < Base
      get '/customers/:customer_id/sessions/new' do
        haml :'sessions/new', locals: { session: Entities::Session.new(customer_id: params[:customer_id]), tasks: Queries::FindTasks.call }
      end

      post '/customers/:customer_id/sessions' do
        begin
          customer_id = params[:customer_id]
          customer = Queries::FindCustomers.call(id: customer_id).first
          raise Actions::Errors::RecordNotFound unless customer

          task = Queries::FindTasks.call(id: [session_params[:task_id]]).first
          raise Actions::Errors::RecordNotFound unless task

          Services::Sessions.create!(session_params.merge(customer_id: customer_id))
          redirect("/customers/#{customer_id}")
        rescue Actions::Errors::RecordNotFound, Services::Errors::RecordInvalid
          status 422
        end
      end

      private

      def session_params
        params[:session]
      end
    end
  end
end
