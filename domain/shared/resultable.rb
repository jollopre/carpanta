require 'dry/monads'

module Carpanta
  module Domain
    module Shared
      module Resultable
        class << self
          def included(base)
            base.include(Dry::Monads[:result])
          end
        end
      end
    end
  end
end
