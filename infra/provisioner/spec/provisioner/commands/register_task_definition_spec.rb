require 'aws-sdk-ecs'
require 'provisioner/commands/register_task_definition'
require_relative '../shared_context'

RSpec.describe Provisioner::Commands::RegisterTaskDefinition do
  include_context 'configuration'

  let(:client) do
    Aws::ECS::Client.new(stub_responses: true)
  end
  let(:container_port) { 80 }
  let(:host_port) { 80 }

  before do
    client.stub_responses(:register_task_definition, response)
  end
  
  let(:response) do
    client.stub_data(:register_task_definition, {
      task_definition: {
        task_definition_arn: 'a_task_definition_arn'
      }
    })
  end

  subject do
    described_class.new(client)
  end

  describe '#call' do
    let(:default_params) do
      {
        container_definitions: [
          {
            image: 'an_image',
            name: 'container_name'
          }
        ],
        cpu: '256',
        execution_role_arn: 'an_execution_role_arn',
        family: 'a_family',
        memory: '512'
      }
    end

    context 'when params is invalid' do
      let(:params) do
        default_params.merge(cpu: '321')
      end

      it 'failure? is true' do
        response = subject.call(params)

        expect(response.failure?).to eq(true)
      end

      it 'failure contains errors' do
        response = subject.call(params)

        expect(response.failure).to include(
          cpu: include(/must be one of/)
        )
      end
    end

    context 'when client fails registering task definition' do
      it 'failure? is true' do
        skip('check client response')
      end
    end

    it 'registers a task definition' do
      subject.call(default_params)

      api_request = client.api_requests.find { |request| request.fetch(:operation_name) == :register_task_definition }
      expect(api_request[:params]).to include(
        family: 'a_family',
        container_definitions: [{
          image: 'an_image',
          name: 'container_name',
          essential: true
        }],
        execution_role_arn: 'an_execution_role_arn',
        network_mode: 'awsvpc',
        requires_compatibilities: ['FARGATE'],
        cpu: '256',
        memory: '512'
      )
    end

    it 'returns the task definition arn' do
      result = subject.call(default_params)

      expect(result.success).to eq('a_task_definition_arn')
    end

    it 'success? is true' do
      response = subject.call(default_params)

      expect(response.success?).to eq(true)
    end

    it 'logs its arn' do
      expect(Provisioner.logger).to receive(:info).with("Task definition created with arn: a_task_definition_arn")

      subject.call(default_params)
    end
  end
end
