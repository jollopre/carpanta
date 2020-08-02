require 'dry-validation'

module Deploy
  module Schemas
    class CreateService < Dry::Validation::Contract
      ZERO = 0.freeze
      Ref = Dry::Schema.Params do
        required(:ref).filled(:string)
      end

      schema do
        optional(:cluster) { str? | (hash? & Ref) }
        required(:service_name).filled(:string)
        required(:task_definition) { str? | (hash? & Ref) }
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
