require_relative 'base'
require 'app/commands/create_customer'
require 'app/commands/create_appointment'
require 'app/queries/show_customers'
require 'app/queries/offers_lookup'
require 'app/queries/show_customer'
require 'app/helpers/form_errors'

module Carpanta
  module Controllers
    class Customers < Base
      get '/customers' do
        result = Queries::ShowCustomers.call

        haml :'customers/index', locals: { customers: result.value! }, layout: :legacy_layout
      end

      get '/customers/new' do
        form_errors = Helpers::FormErrors.new
        haml :'customers/new', {}, { values: {}, form_errors: form_errors }
      end

      post '/customers' do
        result = Commands::CreateCustomer.call(customer_attributes)

        redirect('/customers') if result.success?

        form_errors = Helpers::FormErrors.new(result.failure)
        status 422
        haml :'customers/new', {}, { values: customer_attributes, form_errors: form_errors }
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

        redirect("/customers/#{appointment_params[:customer_id]}") if result.success?

        form_errors = Helpers::FormErrors.new(result.failure)
        offers_result = Queries::OffersLookup.call
        status 422
        haml :'customers/appointments/new', locals: { customer_id: params[:customer_id], offers: offers_result.value!, values: appointment_params, form_errors: form_errors }
      end

      get '/customers/:customer_id/appointments/new' do
        offers_result = Queries::OffersLookup.call

        form_errors = Helpers::FormErrors.new
        haml :'customers/appointments/new', locals: { customer_id: params[:customer_id], offers: offers_result.value!, values: {}, form_errors: form_errors }
      end

      private

      def customer_attributes
        attributes = params.fetch(:customer, {}).deep_symbolize_keys
        attributes.filter { |_,v| v.present? }
      end

      def appointment_params
        attributes = params.fetch(:appointment, {}).deep_symbolize_keys
        attributes = attributes.filter { |_,v| v.present? }
        attributes = attributes.merge(customer_id: params['customer_id'])

        attributes
      end
    end
  end
end
