require 'dry-validation'
require_relative 'resultable'

module Carpanta
  module Domain
    module Shared
      class Validation < Dry::Validation::Contract
        class << self
          include Shared::Resultable

          def call(params = {})
            result = new.call(params)

            return Failure(result.errors.to_h) unless result.errors.empty?

            Success(result.values.data)
          end
        end
      end
    end
  end
end
