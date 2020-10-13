require 'forwardable'
require_relative 'offer_legacy'
require_relative 'errors'
require_relative 'repository_legacy'

module Carpanta
  module Domain
    module Offers
      class Service
        class << self
          extend Forwardable

          def save!(attributes)
            offer = OfferLegacy.build(attributes)

            raise Errors::Invalid unless offer.errors.empty?

            RepositoryLegacy.save!(offer)

            offer
          end

          def_delegators RepositoryLegacy, :find_by_id!
        end
      end
    end
  end
end
