require 'aws-sdk-ecs'
require 'deploy/commands/up'
require 'deploy/commands/create_cluster'

RSpec.describe Deploy::Commands::Up do
  let(:client) do
    Aws::ECS::Client.new(stub_responses: true)
  end
  
  subject do
    described_class.new(client)
  end

  describe '#call' do
    let(:default_params) do
      {
        resources: {
          :"my_cluster" => {
            type: 'Aws::ECS::Cluster',
            properties: {
              cluster_name: 'a_cluster_name'
            }
          },
          :"my_task" => {
            type: 'Aws::ECS::TaskDefinition',
            properties: {
              family: 'a_family',
              execution_role_arn: 'a_execution_role_arn',
              cpu: '256',
              memory: '512',
              container_definitions: []
            }
          }
        }
      }
    end

    it 'creates a cluster' do
      result = subject.call(default_params)

      skip('todo')
    end

    it 'creates a task definition' do
      skip('todo')
    end

    context 'when params are invalid' do
      let(:params) do
        {
          resources: {
            :"my_cluster" => {
              type: 'Aws::ECS::Cluster',
              properties: 'foo'
            }
          }
        }
      end

      it 'returns result with failure' do
        result = subject.call(default_params.merge(params))

        expect(result.failure?).to eq(true)
      end

      it 'failure contains error details' do
        result = subject.call(default_params.merge(params))

        expect(result.failure).to include(
          resources: include(
            :my_cluster => include(
              properties: include('must be a hash')
            )
          )
        )
      end
    end
  end
end
