require 'dry-monads'
require 'dry/monads/do'
require 'deploy/schemas/up'
require 'deploy/commands/create_cluster'
require 'deploy/commands/register_task_definition'
require 'deploy/commands/create_service'

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
        adapted_service_params = adapt_service_params(params: service_params, cluster_pairs: cluster_pairs, task_definition_pairs: task_definition_pairs)
        result = create_service_cmd.call(adapted_service_params)

        if result.failure? && result.failure.include?(:task_definition)
          Deploy.logger.warn("Errors encountered while attempting to create service. Details: #{result.failure.to_json}")
          return Success([])
        end

        return Failure(result.failure) if result.failure?

        Success([
          { logical_name: logical_name, arn: result.success }
        ])
      end

      def adapt_service_params(params:, cluster_pairs:, task_definition_pairs:)
        cluster_logical_name = params.fetch(:cluster, {}).fetch(:ref, nil)
        cluster_pair = cluster_pairs.find { |pair| pair[:logical_name].to_s ==  cluster_logical_name }
        adapted_params = params.reject { |k,_| k == :cluster }
        adapted_params.merge!(cluster: cluster_pair[:arn]) unless cluster_pair.nil?

        task_definition_name = params.fetch(:task_definition, {}).fetch(:ref, nil)
        task_definition_pair = task_definition_pairs.find { |pair| pair[:logical_name].to_s == task_definition_name }
        adapted_params.delete(:task_definition)
        adapted_params.merge!(task_definition: task_definition_pair[:arn]) unless task_definition_pair.nil?

        adapted_params
      end

      def create_service_cmd
        @create_service_cmd ||= CreateService.new(client)
      end
    end
  end
end
