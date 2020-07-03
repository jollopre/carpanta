require 'dry/schema'

module Deploy
  module Schemas
    class RegisterTaskDefinition
      class << self
        def call(params)
          schema.call(params)
        end

        private

        def schema
          @schema ||= Dry::Schema.Params do
            required(:family).filled(:string)
            required(:execution_role_arn).filled(:string)
          end
        end
      end
    end
  end
end
