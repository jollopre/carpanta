require 'dry-validation'
require 'provisioner/schemas/create_cluster'
require 'provisioner/schemas/register_task_definition'
require 'provisioner/schemas/create_service'

module Provisioner
  module Schemas
    class Up < Dry::Validation::Contract
      class Resource < Dry::Validation::Contract
        Cluster = CreateCluster.new
        TaskDefinition = RegisterTaskDefinition.new
        Service = CreateService.new

        PROPERTY_SCHEMAS = {
          'Aws::ECS::Cluster' => Cluster,
          'Aws::ECS::TaskDefinition' => TaskDefinition,
          'Aws::ECS::Service' => Service
        }.freeze
        TYPES = [
          'Aws::ECS::Cluster',
          'Aws::ECS::TaskDefinition',
          'Aws::ECS::Service'
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
