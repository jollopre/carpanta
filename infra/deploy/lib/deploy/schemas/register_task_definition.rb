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
        class PortMapping < Dry::Validation::Contract
          schema do
            required(:container_port).filled(:integer)
            optional(:protocol).value(included_in?: ['tcp', 'udp'])
          end
        end

        class LogConfiguration < Dry::Validation::Contract
          LOG_DRIVER_VALUES = ['awslogs', 'splunk', 'awsfirelens'].freeze

          schema do
            required(:log_driver).value(included_in?: LOG_DRIVER_VALUES)
          end
        end

        schema do
          optional(:environment)
          required(:image).filled(:string)
          required(:name).filled(:string)
          optional(:port_mappings).array(:hash, PortMapping.schema)
          optional(:log_configuration).hash(LogConfiguration.schema)
          #essential = true
        end
      end

      schema do
        required(:container_definitions).array(:hash, ContainerDefinition.schema)
        required(:cpu).value(included_in?: CPU_VALUES)
        required(:execution_role_arn).filled(:string)
        required(:family).filled(:string)
        required(:memory).value(included_in?: MEMORY_VALUES)
        #network_mode = awsvpc
        #requires_compatibilities = [FARGATE]
      end

      rule(:cpu, :memory) do
        memory_range = CPU_MEMORY_RANGES[values[:cpu]]
        key(:memory).failure("must be one of: #{memory_range.join(', ')}") unless memory_range.include?(values[:memory])
      end
    end
  end
end
