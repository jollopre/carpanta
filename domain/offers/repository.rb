require "infra/orm"
require "domain/shared/resultable"

module Carpanta
  module Domain
    module Offers
      class Repository
        include Domain::Shared::Resultable

        def initialize(storage: Infra::ORM::Offer)
          @storage = storage
        end

        def save(offer)
          result = storage.new(offer.to_h).save
          result ? Success() : Failure()
        end

        private

        attr_reader :storage
      end
    end
  end
end
