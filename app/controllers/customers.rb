require_relative 'base'
require 'app/commands/create_customer'
require 'app/commands/create_appointment'
require 'app/queries/show_customers'
require 'app/queries/offers_lookup'
require 'app/queries/show_customer'
require 'app/helpers/error'

module Carpanta
  module Controllers
    class Customers < Base
      get '/customers' do
        result = Queries::ShowCustomers.call

        haml :'customers/index', locals: { customers: result.value! }, layout: :legacy_layout
      end

      get '/customers/new' do
        error_helper = Helpers::Error.new
        haml :'customers/new', {}, { values: {}, error_helper: error_helper }
      end

      post '/customers' do
        result = Commands::CreateCustomer.call(customer_attributes)

        redirect('/customers') if result.success?

        error_helper = Helpers::Error.new(result.failure)
        status 422
        haml :'customers/new', {}, { values: customer_attributes, error_helper: error_helper }
      end

      get '/customers/:customer_id' do
        result = Queries::ShowCustomer.call(params[:customer_id])

        if result.success?
          haml :'customers/show', locals: { customer: result.value! }, layout: :legacy_layout
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
        offers_result = Queries::OffersLookup.call

        haml :'customers/appointments/new', locals: { customer_id: params[:customer_id], offers: offers_result.value! }
      end

      private

      def customer_attributes
        attributes = params.fetch(:customer, {}).deep_symbolize_keys
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
