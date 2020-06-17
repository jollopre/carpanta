require 'aws-sdk-ecs'
require 'deploy/commands/create_cluster'
require_relative '../shared_context'

RSpec.describe Deploy::Commands::CreateCluster do
  include_context 'configuration'

  let(:client) do
    Aws::ECS::Client.new(stub_responses: true)
  end

  before do
    client.stub_responses(:create_cluster, response)
  end

  let(:response) do
    client.stub_data(:create_cluster, {
      cluster: {
        cluster_arn: 'a_cluster_arn'
      }
    })
  end

  describe '.call' do
    it 'creates a cluster with name from configuration' do
      described_class.call(client)

      api_request = client.api_requests.find { |request| request.fetch(:operation_name) == :create_cluster }
      expect(api_request[:params]).to include(
        cluster_name: cluster_name)
    end

    it 'returns the cluster arn' do
      result = described_class.call(client)

      expect(result).to eq('a_cluster_arn')
    end

    it 'logs its arn' do
      pending
    end
  end
end
