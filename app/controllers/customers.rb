require_relative 'base'
require 'app/queries/find_sessions'
require 'app/presenters/customer'
require 'domain/customers/service'

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
          Domain::Customers::Service.create!(customer_params)
          redirect('/customers')
        rescue Domain::Customers::Errors::Invalid
          status 422
        end
      end

      get '/customers/:customer_id' do
        begin
          customer = Domain::Customers::Service.find_by_id(params[:customer_id])

          sessions = Queries::FindSessions.call(customer_id: customer.id, include: :task)

          haml :'customers/show', locals: Presenters::Customer.new(customer: customer, sessions: sessions).attributes
        rescue Domain::Customers::Errors::NotFound
          body 'Customer not found'
          status 404
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
    end
  end
end
