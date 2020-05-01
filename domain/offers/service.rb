require 'forwardable'
require_relative 'offer'
require_relative 'errors'
require_relative 'repository'

module Carpanta
  module Domain
    module Offers
      class Service
        class << self
          extend Forwardable

          def create!(attributes)
            offer = Offer.build(attributes)

            raise Errors::Invalid unless offer.errors.empty?

            Repository.create!(offer)
          end

          def_delegators Repository, :find_by_id!
        end
      end
    end
  end
end
