require 'domain/shared/callable'
require 'domain/shared/do_notation'
require_relative 'validations/on_create'
require_relative 'offer'
require_relative 'repository'

module Carpanta
  module Domain
    module Offers
      module Services
        class CreateOffer
          extend Shared::Callable
          include Shared::DoNotation
        end
      end
    end
  end
end
