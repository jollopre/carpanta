require "forwardable"
require "infra/orm"
require "domain/shared/callable"
require "domain/shared/resultable"

module Carpanta
  module Queries
    class ShowCustomers
      extend Domain::Shared::Callable
      include Domain::Shared::Resultable

      def initialize(relation: Infra::ORM::Customer.all)
        @relation = relation
      end

      def call
        result = relation.offset(0).limit(100).order(:created_at)
        customers = result.map do |customer|
          Customer.new(customer)
        end
        Success(customers)
      end

      private

      attr_reader :relation

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
