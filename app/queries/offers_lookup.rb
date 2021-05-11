require "infra/orm"
require "domain/shared/callable"
require "domain/shared/resultable"

module Carpanta
  module Queries
    class OffersLookup
      extend Domain::Shared::Callable
      include Domain::Shared::Resultable

      def initialize(relation: Infra::ORM::Offer.all)
        @relation = relation
      end

      def call
        offers = relation.pluck(:id, :tasks).map do |attributes|
          id, tasks = attributes
          Lookup.new(id: id, tasks: tasks)
        end
        Success(offers)
      end

      private

      attr_reader :relation
    end

    class Lookup
      attr_reader :id

      def initialize(params = {})
        @id = params.fetch(:id)
        @tasks = params.fetch(:tasks)
      end

      def label
        @tasks.to_sentence
      end
    end
  end
end
