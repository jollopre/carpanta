module Deploy
  module Commands
    class CreateCluster
      def initialize(client)
        @client = client
      end

      def call
        response = client.create_cluster({
          cluster_name: cluster_name
        })
        cluster_arn = response.cluster.cluster_arn
        log_cluster_created(cluster_arn)

        cluster_arn
      end

      private

      attr_reader :client

      def cluster_name
        Deploy.configuration.cluster_name
      end

      def logger
        Deploy.logger
      end

      def log_cluster_created(arn)
        logger.info("Cluster created with arn: #{arn}")
      end
    end
  end
end
