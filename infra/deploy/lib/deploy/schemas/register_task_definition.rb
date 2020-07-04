require 'dry-schema'
require 'dry-types'

module Deploy
  module Schemas
    class RegisterTaskDefinition
      class Types
        include Dry.Types()
        CPU = String.enum('256', '512', '1024', '2048', '4096').freeze
        MEMORY = String.enum(*['512', (1024..30720).step(1024).map(&:to_s)].flatten).freeze
      end

      class << self
        def call(params)
          schema.call(params)
        end

        private

        def schema
          @schema ||= Dry::Schema.Params do
            required(:family).filled(:string)
            required(:execution_role_arn).filled(:string)
            required(:cpu).filled(Types::CPU)
            required(:memory).filled(Types::MEMORY)
          end
        end
      end
    end
  end
end
