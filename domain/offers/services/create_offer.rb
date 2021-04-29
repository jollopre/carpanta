require "domain/shared/callable"
require "domain/shared/resultable"
require "domain/shared/do_notation"
require "domain/offers/validations/on_create"
require "domain/offers/offer"
require "domain/offers/repository"

module Carpanta
  module Domain
    module Offers
      module Services
        class CreateOffer
          extend Shared::Callable
          include Shared::Resultable
          include Shared::DoNotation

          def initialize(repository: Repository.new)
            @repository = repository
          end

          def call(params = {})
            sanitized_params = yield validate(params)
            offer = Offer.new(sanitized_params)
            yield create(offer)

            Success(offer.id)
          end

          private

          attr_reader :repository

          def validate(params)
            Validations::OnCreate.call(params)
          end

          def create(offer)
            repository.save(offer)
          end
        end
      end
    end
  end
end
