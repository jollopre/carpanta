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
    before do
      client.stub_responses(:create_cluster, { cluster: { cluster_arn: 'a_cluster_arn' }})
      client.stub_responses(:register_task_definition, { task_definition: { task_definition_arn: 'a_task_definition_arn' }})
    end

    let(:default_params) do
      {
        resources: {
          my_cluster: {
            type: 'Aws::ECS::Cluster',
            properties: {
              cluster_name: 'a_cluster_name'
            }
          },
          my_task: {
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

      expect(result.success).to include(
        cluster: include(
          logical_name: :my_cluster,
          arn: 'a_cluster_arn'
        )
      )
    end

    it 'creates a task definition' do
      result = subject.call(default_params)

      expect(result.success).to include(
        task_definition: include(
          logical_name: :my_task,
          arn: 'a_task_definition_arn'
        )
      )
    end

    context 'when params are invalid' do
      let(:params) do
        {
          resources: {
            my_cluster: {
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
            my_cluster: include(
              properties: include('must be a hash')
            )
          )
        )
      end
    end

    context 'when there are no clusters defined under resources' do
      before do
        default_params.fetch(:resources).delete(:my_cluster)
      end

      it 'result returns an empty cluster' do
        result = subject.call(default_params)

        expect(result.success).to include(
          cluster: []
        )
      end
    end

    context 'when there are no task_definitions defined under resources' do
      before do
        default_params.fetch(:resources).delete(:my_task)
      end

      it 'result returns an empty task_definition' do
        result = subject.call(default_params)

        expect(result.success).to include(
          task_definition: []
        )
      end
    end
  end
end
