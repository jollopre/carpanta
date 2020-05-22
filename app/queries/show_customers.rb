require 'forwardable'
require 'infra/orm'

module Carpanta
  module Queries
    class ShowCustomers
      attr_reader :relation

      def initialize(relation = Infra::ORM::Customer.all)
        @relation = relation
      end

      def call
        customers = relation.offset(0).limit(100).order(:created_at)
        customers.map do |customer|
          Customer.new(customer)
        end
      end

      class Customer
        extend Forwardable

        def_delegators :@customer, :id, :name, :surname, :email, :phone

        def initialize(customer)
          @customer = customer
        end
      end
    end
  end
end
