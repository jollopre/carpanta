require_relative 'base'
require 'domain/customers/service'
require 'domain/customers/errors'
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
        haml :'customers/new', locals: { customer: Domain::Customers::Customer.build }
      end

      post '/customers' do
        begin
          Domain::Customers::Service.save!(customer_params)
          redirect('/customers')
        rescue Domain::Customers::Errors::Invalid, Domain::Customers::Errors::EmailNotUnique
          status 422
        end
      end

      get '/customers/:customer_id' do
        customer = Queries::ShowCustomer.new.call(params[:customer_id])

        if customer
          haml :'customers/show', locals: { customer: customer }
        else
          body 'Customer not found'
          status 404
        end
      end

      post '/customers/:customer_id/appointments' do
        result = Commands::CreateAppointment.call(appointment_params)
        result.success do
          redirect("/customers/#{appointment_params[:customer_id]}")
        end
        result.failure do |errors|
          body(errors.to_json)
          status 422
        end
      end

      get '/customers/:customer_id/appointments/new' do
        haml :'customers/appointments/new', locals: { customer_id: params[:customer_id], offers: Queries::OffersQuery.new.to_a }
      end

      private

      def customer_params
        attrs = params.fetch(:customer, {})
        customer = {}
        customer[:name] = attrs['name']
        customer[:surname] = attrs['surname']
        customer[:email] = attrs['email']
        customer[:phone] = attrs['phone']
        customer
      end

      def appointment_params
        appointment = params.fetch(:appointment, {}).deep_symbolize_keys
        appointment[:customer_id] = params['customer_id']

        appointment
      end
    end
  end
end
