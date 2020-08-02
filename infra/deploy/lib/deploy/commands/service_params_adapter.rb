require 'dry-monads'

module Deploy
  module Commands
    class ServiceParamsAdapter
      include Dry::Monads[:result]
      include Dry::Monads::Do.for(:call)

      def initialize(params:, cluster_pairs:, task_definition_pairs:)
        @params = params
        @cluster_pairs = cluster_pairs
        @task_definition_pairs = task_definition_pairs
        @errors = {}
      end

      def call
        params_with_arns = yield replace_params_refs_with_arns

        Success(
          params.merge(params_with_arns)
        )
      end

      private

      attr_reader :params, :cluster_pairs, :task_definition_pairs, :errors

      def replace_params_refs_with_arns
        cluster_pair = find_cluster_pair
        task_definition_pair = find_task_definition_pair

        errors = {}
        errors.merge!(cluster_pair.failure) unless cluster_pair.success?
        errors.merge!(task_definition_pair.failure) unless task_definition_pair.success?
        return Failure(errors) unless errors.empty?

        Success(
          cluster: cluster_pair.value![:arn],
          task_definition: task_definition_pair.value![:arn]
        )
      end

      def find_cluster_pair
        cluster_prop = params.fetch(:cluster, nil) #TODO assumes cluster property comes when indeed is optional on its schema
        return Success(arn: cluster_prop) unless is_a_ref?(cluster_prop)

        find_pair_by_ref(:cluster, cluster_prop.fetch(:ref))
      end

      def find_task_definition_pair
        task_definition_prop = params.fetch(:task_definition, nil)
        return Success(arn: task_definition_prop) unless is_a_ref?(task_definition_prop)

        find_pair_by_ref(:task_definition, task_definition_prop.fetch(:ref))
      end

      def is_a_ref?(property)
        property.is_a?(Hash)
      end

      def find_pair_by_ref(pairs_type, ref)
        pairs = pairs_type == :cluster ? cluster_pairs : task_definition_pairs
        pair = pairs.find do |pair|
          pair[:logical_name].to_s == ref
        end
        pair.nil? ? Failure({ pairs_type => 'logical name not found' }) : Success(pair)
      end
    end
  end
end
