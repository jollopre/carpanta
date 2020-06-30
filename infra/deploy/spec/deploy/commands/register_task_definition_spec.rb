require 'aws-sdk-ecs'
require 'deploy/commands/register_task_definition'
require_relative '../shared_context'

RSpec.describe Deploy::Commands::RegisterTaskDefinition do
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
    it 'registers a task definition' do
      subject.call

      api_request = client.api_requests.find { |request| request.fetch(:operation_name) == :register_task_definition }
      expect(api_request[:params]).to include(
        family: family,
        container_definitions: [
          {
            name: container_name,
            image: container_image,
            # port_mappings: [
            #   container_port: container_port,
            #   host_port: host_port,
            #   protocol: 'tcp'
            # ],
            # environment: [],
            # essential: true,
            # log_configuration: {
            #   log_driver: 'awslogs',
            #   options: {
            #     "awslogs-create-group" => true,
            #     "awslogs-group" => "/ecs/#{container_name}",
            #     "awslogs-region" => 'a_region',
            #     "awslogs-stream-prefix" => family
            #   }
            # }
          }
        ],
        execution_role_arn: execution_role_arn,
        network_mode: 'awsvpc',
        requires_compatibilities: ['FARGATE'],
        cpu: '256',
        memory: '512'
      )
    end

    it 'returns the task definition arn' do
      result = subject.call

      expect(result).to eq('a_task_definition_arn')
    end

    it 'logs its arn' do
      expect(Deploy.logger).to receive(:info).with("Task definition created with arn: a_task_definition_arn")

      subject.call
    end
  end
end
