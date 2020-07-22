require 'dry-validation'
require 'deploy/schemas/create_cluster'
require 'deploy/schemas/register_task_definition'

module Deploy
  module Schemas
    class Up < Dry::Validation::Contract
      class Resource < Dry::Validation::Contract
        Cluster = CreateCluster.new
        TaskDefinition = RegisterTaskDefinition.new

        PROPERTY_SCHEMAS = {
          'Aws::ECS::Cluster' => Cluster,
          'Aws::ECS::TaskDefinition' => TaskDefinition
        }.freeze
        TYPES = [
          'Aws::ECS::Cluster',
          'Aws::ECS::TaskDefinition'
        ].freeze

        schema do
          required(:type).value(included_in?: TYPES)
          required(:properties).filled(:hash)
        end

        rule(:properties, :type) do
          type = values[:type]
          schema = PROPERTY_SCHEMAS.fetch(type)
          result = schema.call(value)
          next unless result.failure?

          result.errors.each do |message|
            key([:properties, *message.path]).failure(message.text)
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
