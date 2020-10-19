require 'domain/shared/entity'

module Carpanta
  module Domain
    module Offers
      class Offer < Shared::Entity
        attr_reader :tasks, :price

        def initialize(params = {})
          super(params[:id])
          @tasks = params[:tasks]
          @price = params[:price]
        end
      end
    end
  end
end
