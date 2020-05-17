require_relative 'base'
require 'app/queries/find_sessions'
require 'app/presenters/customer'
require 'domain/customers/service'
require 'domain/customers/errors'
require 'app/commands/create_appointment'

module Carpanta
  module Controllers
    class Customers < Base
      get '/customers' do
        haml :'customers/index', locals: { customers: Domain::Customers::Service.find_all }
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
        begin
          customer = Domain::Customers::Service.find_by_id!(params[:customer_id])

          sessions = Queries::FindSessions.call(customer_id: customer.id, include: :task)

          haml :'customers/show', locals: Presenters::Customer.new(customer: customer, sessions: sessions).attributes
        rescue Domain::Customers::Errors::NotFound
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
