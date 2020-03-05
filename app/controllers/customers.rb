require_relative 'base'
require 'app/entities/customer'
require 'app/services/customers'
require 'app/queries/find_customers'
require 'app/services/errors'

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
          Services::Customers.create!(filtered_params)
          redirect('/customers')
        rescue Services::Errors::RecordInvalid
          status 422
        end
      end

      private

      def filtered_params
        params['customer']
      end
    end
  end
end
