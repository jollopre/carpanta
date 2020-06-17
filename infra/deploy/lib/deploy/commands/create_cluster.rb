module Deploy
  module Commands
    class CreateCluster
      class << self
        def call(client)
          response = client.create_cluster({
            cluster_name: cluster_name
          })

          response.cluster.cluster_arn
        end

        private

        def cluster_name
          Deploy.configuration.cluster_name
        end
      end
    end
  end
end
