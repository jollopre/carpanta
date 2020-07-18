require 'dry-validation'
require 'deploy/schemas/create_cluster'

module Deploy
  module Schemas
    class Up < Dry::Validation::Contract
      #config.validate_keys = true

      class Resource < Dry::Validation::Contract
        schema do
          required(:type).filled(:string)
          required(:properties).filled(:hash)
        end

        rule(:properties, :type) do
          if values[:type] == 'Aws::ECS::Cluster'
            result = CreateCluster.new.call(value)
            if result.failure?
              result.errors.each do |message|
                key([:properties, *message.path]).failure(message.text)
              end
            end
          end
        end
      end

      ResourceContract = Resource.new

      schema do
        required(:resources).filled(:hash)
      end

      rule(:resources) do
        values[:resources].each do |key,value|
          res = ResourceContract.call(value)

          next unless res.failure?

          # errors is an instance of Dry::Schema::MessageSet
          # containing Dry::Schema::Message objects
          res.errors.each do |message|
            key([:resources, key, *message.path]).failure(message.text)
          end
        end
      end
    end
  end
end
