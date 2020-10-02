require 'dry-validation'
require_relative 'resultable'

module Carpanta
  module Domain
    module Shared
      class Validation < Dry::Validation::Contract
        class << self
          include Resultable

          def call(params = {})
            result = contract.call(params)
            return Failure(result.errors.to_h) unless result.errors.empty?

            Success(result.values.data)
          end

          private

          def contract
            @contract ||= new
          end
        end
      end
    end
  end
end
