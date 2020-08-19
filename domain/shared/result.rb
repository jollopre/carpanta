require 'dry/monads'

module Carpanta
  module Domain
    module Shared
      module Result
        include Dry::Monads[:result]

        def success(value)
          Success(value)
        end

        def failure(value)
          Failure(value)
        end
      end
    end
  end
end
