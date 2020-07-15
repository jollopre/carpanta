require 'dry-validation'

module Deploy
  module Schemas
    class RegisterTaskDefinition < Dry::Validation::Contract
      CPU_VALUES = ['256', '512', '1024', '2048', '4096'].freeze
      MEMORY_VALUES = ['512', (1024..30720).step(1024).map(&:to_s)].flatten.freeze
      CPU_MEMORY_RANGES = {
        '256' => ['512', '1024', '2048'],
        '512' => ['1024', '2048', '3072', '4096'],
        '1024' => (2048..8192).step(1024).map(&:to_s),
        '2048' => (4096..16384).step(1024).map(&:to_s),
        '4096' => (8192..30720).step(1024).map(&:to_s)
      }.freeze

      class ContainerDefinition < Dry::Validation::Contract
        class Environment < Dry::Validation::Contract
          config.validate_keys = true

          schema do
            required(:name).filled(:string)
            required(:value).filled(:string)
          end
        end

        class PortMapping < Dry::Validation::Contract
          config.validate_keys = true

          schema do
            required(:container_port).filled(:integer)
            optional(:protocol).value(included_in?: ['tcp', 'udp'])
          end
        end

        class LogConfiguration < Dry::Validation::Contract
          LOG_DRIVER_VALUES = ['awslogs', 'splunk', 'awsfirelens'].freeze
          config.validate_keys = true

          schema do
            required(:log_driver).value(included_in?: LOG_DRIVER_VALUES)
            optional(:options).filled(:hash) do
              optional(:"awslogs-create-group").filled(:string)
              optional(:"awslogs-group").filled(:string)
              optional(:"awslogs-region").filled(:string)
              optional(:"awslogs-stream").filled(:string)
            end
          end

          rule(options: :"awslogs-region") do
            key.failure('is missing') if values[:log_driver] == 'awslogs' && value.nil?
          end

          rule(options: :"awslogs-group") do
            key.failure('is missing') if values[:log_driver] == 'awslogs' && value.nil?
          end
        end

        config.validate_keys = true

        schema do
          optional(:environment).array(:hash, Environment.schema)
          required(:image).filled(:string)
          required(:name).filled(:string)
          optional(:port_mappings).array(:hash, PortMapping.schema)
          optional(:log_configuration).hash(LogConfiguration.schema)
        end
      end

      config.validate_keys = true

      schema do
        required(:container_definitions).array(:hash, ContainerDefinition.schema)
        required(:cpu).value(included_in?: CPU_VALUES)
        required(:execution_role_arn).filled(:string)
        required(:family).filled(:string)
        required(:memory).value(included_in?: MEMORY_VALUES)
      end

      rule(:cpu, :memory) do
        memory_range = CPU_MEMORY_RANGES[values[:cpu]]
        key(:memory).failure("must be one of: #{memory_range.join(', ')}") unless memory_range.include?(values[:memory])
      end
    end
  end
end
