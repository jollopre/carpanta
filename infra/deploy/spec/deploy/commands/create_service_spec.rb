require 'aws-sdk-ecs'
require 'deploy/commands/create_service'

RSpec.describe Deploy::Commands::CreateService do
  let(:client) do
    Aws::ECS::Client.new(stub_responses: true)
  end

  before do
    client.stub_responses(:create_service, {
      service: {
        service_arn: 'a_service_arn'
      }
    })
  end

  subject do
    described_class.new(client)
  end

  describe '#call' do
    let(:default_params) do
      {
        cluster: 'a_cluster_name',
        service_name: 'a_service_name',
        task_definition: 'a_task_definition',
        desired_count: 1,
        network_configuration: {
          awsvpc_configuration: {
            subnets: ['a_subnet'],
            security_groups: ['a_security_group'],
            assign_public_ip: 'ENABLED'
          }
        }
      }
    end

    context 'when params are invalid' do
      let(:params) do
        default_params.merge(service_name: 1234)
      end

      it 'failure? is true' do
        response = subject.call(params)

        expect(response.failure?).to eq(true)
      end

      it 'failure contains errors' do
        response = subject.call(params)

        expect(response.failure).to include(
          service_name: include('must be a string')
        )
      end
    end

    context 'when client fails creating cluster' do
      it 'failure? is true' do
        skip('check client response')
      end
    end

    it 'creates a service with params passed' do
      subject.call(default_params)

      api_request = client.api_requests.find { |request| request.fetch(:operation_name) == :create_service }
      expect(api_request[:params]).to include(
        service_name: 'a_service_name',
        scheduling_strategy: 'REPLICA',
        launch_type: 'FARGATE'
      )
    end

    it 'success? is true' do
      response = subject.call(default_params)

      expect(response.success?).to eq(true)
    end

    it 'returns the service arn' do
      result = subject.call(default_params)

      expect(result.success).to eq('a_service_arn')
    end

    it 'logs its arn' do
      expect(Deploy.logger).to receive(:info).with('Service created with arn: a_service_arn')

      subject.call(default_params)
    end
  end
end
