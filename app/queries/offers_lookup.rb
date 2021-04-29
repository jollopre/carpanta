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
          Offer.new(id: id, tasks: tasks)
        end
        Success(offers)
      end

      private

      attr_reader :relation
    end

    class Offer
      attr_reader :id

      def initialize(params = {})
        @id = params[:id]
        @tasks = params[:tasks]
      end

      def label
        tasks.to_sentence
      end

      private

      attr_reader :tasks
    end
  end
end
