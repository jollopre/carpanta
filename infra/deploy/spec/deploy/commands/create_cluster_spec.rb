require 'aws-sdk-ecs'
require 'deploy/commands/create_cluster'
require_relative '../shared_context'

RSpec.describe Deploy::Commands::CreateCluster do
  include_context 'configuration'

  let(:client) do
    Aws::ECS::Client.new(stub_responses: true)
  end
  let(:cluster_arn) { 'a_cluster_arn' }

  before do
    client.stub_responses(:create_cluster, response)
  end

  let(:response) do
    client.stub_data(:create_cluster, {
      cluster: {
        cluster_arn: cluster_arn
      }
    })
  end

  subject do
    described_class.new(client)
  end

  describe '#call' do
    it 'creates a cluster with name from configuration' do
      subject.call

      api_request = client.api_requests.find { |request| request.fetch(:operation_name) == :create_cluster }
      expect(api_request[:params]).to include(
        cluster_name: cluster_name)
    end

    it 'returns the cluster arn' do
      result = subject.call

      expect(result).to eq('a_cluster_arn')
    end

    it 'logs its arn' do
      expect(Deploy.logger).to receive(:info).with("Cluster created with arn: #{cluster_arn}")

      subject.call
    end
  end
end
