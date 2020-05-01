require 'domain/shared/entity'

module Carpanta
  module Domain
    module Offers
      class Offer < Shared::Entity
        ZERO = 0.freeze
        attr_reader :tasks, :price

        validates_presence_of :tasks, :price
        validates_numericality_of :price, only_integer: true, greater_than: ZERO
        validates_array_of :tasks, only_string: true

        def name
          tasks.to_sentence
        end

        def attributes
          super.merge({ tasks: tasks, price: price })
        end

        private

        def initialize(tasks: nil, price: nil)
          @tasks = tasks
          @price = price
        end

        class << self
          def build(tasks: nil, price: nil)
            offer = new(tasks: tasks, price: price)

            offer.validate

            offer
          end
        end
      end
    end
  end
end
