require "dry/monads/do"

module Carpanta
  module Domain
    module Shared
      module DoNotation
        class << self
          def included(base)
            base.include(Dry::Monads::Do.for(:call))
          end
        end
      end
    end
  end
end
