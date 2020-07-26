require 'dry-validation'

module Deploy
  module Schemas
    class CreateService < Dry::Validation::Contract
      ZERO = 0.freeze
      schema do
        optional(:cluster).filled(:string)
        required(:service_name).filled(:string)
        required(:task_definition).filled(:string)
        required(:desired_count).value(:integer, gt?: ZERO)
        required(:network_configuration).value(:hash) do
          required(:awsvpc_configuration).value(:hash) do
            required(:subnets).array(:string)
            optional(:security_groups).array(:string)
            optional(:assign_public_ip).value(included_in?: ['ENABLED', 'DISABLED'])
          end
        end
      end
    end
  end
end
