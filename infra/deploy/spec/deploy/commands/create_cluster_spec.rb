require 'aws-sdk-ecs'
require 'deploy/commands/create_cluster'

RSpec.describe Deploy::Commands::CreateCluster do
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
    let(:cluster_name) { 'a_cluster_name' }
    let(:default_params) do
      {
        cluster_name: 'a_cluster_name'
      }
    end

    context 'when params is invalid' do
      let(:params) do
        default_params.merge(cluster_name: 1234)
      end

      it 'failure? is true' do
        response = subject.call(params)

        expect(response.failure?).to eq(true)
      end

      it 'failure contains errors' do
        response = subject.call(params)

        expect(response.failure).to include(
          cluster_name: include('must be a string')
        )
      end
    end

    context 'when client fails creating cluster' do
      it 'failure? is true' do
        skip('check client response')
      end
    end

    context 'when cluster_name is missing' do
      it 'creates a default cluster name' do
        default_params.delete(:cluster_name)

        subject.call(default_params)

        api_request = client.api_requests.find { |request| request.fetch(:operation_name) == :create_cluster }
        expect(api_request[:params]).to include(
        cluster_name: 'default_cluster')
      end
    end

    it 'creates a cluster with params passed' do
      subject.call(default_params)

      api_request = client.api_requests.find { |request| request.fetch(:operation_name) == :create_cluster }
      expect(api_request[:params]).to include(
        cluster_name: cluster_name)
    end

    it 'success? is true' do
      response = subject.call(default_params)

      expect(response.success?).to eq(true)
    end

    it 'returns the cluster arn' do
      result = subject.call(default_params)

      expect(result.success).to eq('a_cluster_arn')
    end

    it 'logs its arn' do
      expect(Deploy.logger).to receive(:info).with("Cluster created with arn: #{cluster_arn}")

      subject.call(default_params)
    end
  end
end
