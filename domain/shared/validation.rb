require 'dry-validation'
require_relative 'resultable'
require_relative 'callable'

module Carpanta
  module Domain
    module Shared
      class Validation < Dry::Validation::Contract
        extend Shared::Callable
        include Shared::Resultable

        def call(params = {})
          result = super
          return Failure(result.errors.to_h) unless result.errors.empty?

          Success(result.values.data)
        end
      end
    end
  end
end
