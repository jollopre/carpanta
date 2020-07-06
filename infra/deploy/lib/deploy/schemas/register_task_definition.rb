require 'dry-types'
require 'dry-validation'

module Deploy
  module Schemas
    class RegisterTaskDefinition < Dry::Validation::Contract
      class Types
        include Dry.Types()
        CPU = String.enum('256', '512', '1024', '2048', '4096').freeze
        MEMORY = String.enum(*['512', (1024..30720).step(1024).map(&:to_s)].flatten).freeze
      end

      CPU_MEMORY_RANGES = {
        '256' => ['512', '1024', '2048'],
        '512' => ['1024', '2048', '3072', '4096'],
        '1024' => (2048..8192).step(1024).map(&:to_s),
        '2048' => (4096..16384).step(1024).map(&:to_s),
        '4096' => (8192..30720).step(1024).map(&:to_s)
      }.freeze

      schema do
        required(:container_definitions).array(:hash) do
          required(:environment)
          required(:image)
          required(:name)
          required(:port_mappings)
          required(:log_configuration)
        end
        required(:cpu).filled(Types::CPU)
        required(:execution_role_arn).filled(:string)
        required(:family).filled(:string)
        required(:memory).filled(Types::MEMORY)
      end

      rule(:cpu, :memory) do
        memory_range = CPU_MEMORY_RANGES[values[:cpu]]
        key(:memory).failure("must be one of: #{memory_range.join(', ')}") unless memory_range.include?(values[:memory])
      end
    end
  end
end
