module Deploy
  module Commands
    class CreateCluster
      class << self
        def call(client)
          response = client.create_cluster({
            cluster_name: cluster_name
          })
          cluster_arn = response.cluster.cluster_arn
          logger.info("#{self.name} with arn: #{cluster_arn}")

          cluster_arn
        end

        private

        def cluster_name
          Deploy.configuration.cluster_name
        end

        def logger
          Deploy.logger
        end
      end
    end
  end
end
