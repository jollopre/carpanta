require 'deploy/commands/create_cluster'

module Deploy
  module Commands
    class Up
      def initialize(client)
        @client = client
      end

      def call
        CreateCluster.new(client).call
      end

      private

      attr_reader :client
    end
  end
end
