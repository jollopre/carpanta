require 'infra/orm'

module Carpanta
  module Queries
    class OffersQuery
      attr_reader :relation

      def initialize(relation = Infra::ORM::Offer.all)
        @relation = relation
      end

      def to_a
        relation.pluck(:id, :tasks, :price).map do |attrs|
          Offer.new(id: attrs[0], tasks: attrs[1], price: attrs[2])
        end
      end
    end

    class Offer
      attr_reader :id, :tasks, :price

      def initialize(args = {})
        @id = args[:id]
        @tasks = args[:tasks]
        @price = args[:price]
      end

      def name
        tasks.to_sentence
      end
    end
  end
end
