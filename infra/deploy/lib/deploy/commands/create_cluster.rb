require 'dry-monads'
require 'deploy/schemas/create_cluster'

module Deploy
  module Commands
    class CreateCluster
      DEFAULT_CLUSTER_NAME = 'default_cluster'.freeze

      include Dry::Monads[:result]

      def initialize(client)
        @client = client
        @schema = Schemas::CreateCluster.new
      end

      def call(params)
        result = schema.call(params)
        return Failure(result.errors.to_h) if result.failure?

        values = result.values
        response = client.create_cluster({
          cluster_name: values[:cluster_name] || DEFAULT_CLUSTER_NAME
        })
        cluster_arn = response.cluster.cluster_arn
        log_cluster_created(cluster_arn)

        Success(cluster_arn)
      end

      private

      attr_reader :client, :schema

      def logger
        Deploy.logger
      end

      def log_cluster_created(arn)
        logger.info("Cluster created with arn: #{arn}")
      end
    end
  end
end
