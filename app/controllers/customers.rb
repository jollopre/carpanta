require_relative 'base'
require 'app/entities/customer'
require 'app/services/customers'
require 'app/queries/find_customers'
require 'app/queries/find_sessions'
require 'app/services/errors'
require 'app/actions/errors'

module Carpanta
  module Controllers
    class Customers < Base
      get '/customers' do
        haml :'customers/index', locals: { customers: Queries::FindCustomers.call }
      end

      get '/customers/new' do
        haml :'customers/new', locals: { customer:  Entities::Customer.new }
      end

      post '/customers' do
        begin
          Services::Customers.create!(customer_params)
          redirect('/customers')
        rescue Services::Errors::RecordInvalid
          status 422
        end
      end

      get '/customers/:customer_id' do
        begin
          customer = Queries::FindCustomers.call(id: params[:customer_id]).first
          raise Actions::Errors::RecordNotFound unless customer

          sessions = Queries::FindSessions.call(customer_id: customer.id, include: :task)

          haml :'customers/show', locals: { customer: customer, sessions: sessions }
        rescue Actions::Errors::RecordNotFound
          body 'Customer not found'
          status 404
        end
      end

      private

      def customer_params
        params[:customer]
      end
    end
  end
end
