require_relative 'base'
require 'app/commands/create_customer'
require 'app/commands/create_appointment'
require 'app/queries/show_customers'
require 'app/queries/offers_query'
require 'app/queries/show_customer'

module Carpanta
  module Controllers
    class Customers < Base
      get '/customers' do
        haml :'customers/index', locals: { customers: Queries::ShowCustomers.new.call }
      end

      get '/customers/new' do
        haml :'customers/new', locals: { customer: Domain::Customers::CustomerLegacy.build }
      end

      post '/customers' do
        result = Commands::CreateCustomer.call(customer_attributes)

        redirect('/customers') if result.success?

        status 422
      end

      get '/customers/:customer_id' do
        result = Queries::ShowCustomer.call(params[:customer_id])

        if result.success?
          haml :'customers/show', locals: { customer: result.value! }
        else
          body 'Customer not found'
          status 404
        end
      end

      post '/customers/:customer_id/appointments' do
        result = Commands::CreateAppointment.call(appointment_params)

        if result.success?
          redirect("/customers/#{appointment_params[:customer_id]}")
        else
          body(result.failure.to_json)
          status 422
        end
      end

      get '/customers/:customer_id/appointments/new' do
        haml :'customers/appointments/new', locals: { customer_id: params[:customer_id], offers: Queries::OffersQuery.new.to_a }
      end

      private

      def customer_attributes
        attributes = params.fetch(:customer, {})
        attributes.filter { |_,v| v.present? }
      end

      def appointment_params
        appointment = params.fetch(:appointment, {}).deep_symbolize_keys
        appointment[:customer_id] = params['customer_id']

        appointment
      end
    end
  end
end
