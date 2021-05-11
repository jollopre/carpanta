require "infra/orm"
require "domain/shared/callable"
require "domain/shared/resultable"

module Carpanta
  module Queries
    class CustomersLookup
      extend Domain::Shared::Callable
      include Domain::Shared::Resultable

      def initialize(relation: Infra::ORM::Customer.all)
        @relation = relation
      end

      def call
        customers = relation.pluck(:id, :name, :surname).map do |attributes|
          id, name, surname = attributes
          Lookup.new(id: id, name: name, surname: surname)
        end
        Success(customers)
      end

      private

      attr_reader :relation

      class Lookup
        attr_reader :id

        def initialize(params = {})
          @id = params.fetch(:id)
          @name = params.fetch(:name)
          @surname = params.fetch(:surname)
        end

        def label
          "#{@surname}, #{@name}"
        end
      end
    end
  end
end
