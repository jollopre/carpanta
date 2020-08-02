require 'dry-monads'
require 'dry/monads/do'
require 'deploy/schemas/up'
require 'deploy/commands/create_cluster'
require 'deploy/commands/register_task_definition'
require 'deploy/commands/create_service'
require 'deploy/commands/service_params_adapter'

module Deploy
  module Commands
    class Up
      include Dry::Monads[:result]
      include Dry::Monads::Do.for(:call)

      def initialize(client)
        @client = client
        @schema = Schemas::Up.new
      end

      def call(params = {})
        values = yield validate(params)
        cluster_pairs = yield create_clusters(values)
        task_definition_pairs = yield register_task_definitions(values)
        service_pairs = yield create_services(
          params: values,
          cluster_pairs: cluster_pairs,
          task_definition_pairs: task_definition_pairs
        )

        Success(
          cluster: cluster_pairs,
          task_definition: task_definition_pairs,
          service: service_pairs
        )
      end

      private

      attr_reader :client, :schema

      def validate(params)
        result = schema.call(params)
        return Failure(result.errors.to_h) if result.failure?

        Success(result.values)
      end

      def create_clusters(filtered_params)
        resources = filtered_params.fetch(:resources)
        clusters_params = resources.select do |_,v|
          v.fetch(:type) == 'Aws::ECS::Cluster'
        end

        return Success([]) if clusters_params.empty?

        logical_name = clusters_params.keys[0]
        cluster_params = clusters_params.fetch(logical_name).fetch(:properties)
        result = create_cluster_cmd.call(cluster_params)

        return Failure(result.failure) if result.failure?

        Success([
          { logical_name: logical_name, arn: result.success }
        ])
      end

      def create_cluster_cmd
        @create_cluster_cmd ||= CreateCluster.new(client)
      end

      def register_task_definitions(filtered_params)
        resources = filtered_params.fetch(:resources)
        task_definitions_params = resources.select do |_,v|
          v.fetch(:type) == 'Aws::ECS::TaskDefinition'
        end

        return Success([]) if task_definitions_params.empty?

        logical_name = task_definitions_params.keys[0]
        task_definition_params = task_definitions_params.fetch(logical_name).fetch(:properties)
        result = register_task_definition_cmd.call(task_definition_params)

        return Failure(result.failure) if result.failure?

        Success([
          { logical_name: logical_name, arn: result.success }
        ])
      end

      def register_task_definition_cmd
        @register_task_definition_cmd ||= RegisterTaskDefinition.new(client)
      end

      def create_services(params: , cluster_pairs:, task_definition_pairs:)
        resources = params.fetch(:resources)
        services_params = resources.select do |_,v|
          v.fetch(:type) == 'Aws::ECS::Service'
        end

        return Success([]) if services_params.empty?

        logical_name = services_params.keys[0]
        service_params = services_params.fetch(logical_name).fetch(:properties)
        result = ServiceParamsAdapter.new(params: service_params, cluster_pairs: cluster_pairs, task_definition_pairs: task_definition_pairs).call
        unless result.success?
          return Failure(
            resources: {
              logical_name => {
                properties: result.failure
              }
            })
        end

        result = create_service_cmd.call(result.value!)

        return Failure(result.failure) if result.failure?

        Success([
          { logical_name: logical_name, arn: result.success }
        ])
      end

      def create_service_cmd
        @create_service_cmd ||= CreateService.new(client)
      end
    end
  end
end
