require 'aws-sdk-ecs'
require 'deploy/commands/up'

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
      client.stub_responses(:create_service, { service: { service_arn: 'a_service_arn' }})
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
          },
          my_service: {
            type: 'Aws::ECS::Service',
            properties: {
              cluster: { ref: 'my_cluster' },
              service_name: 'a_service_name',
              task_definition: { ref: 'my_task' },
              desired_count: 1,
              network_configuration: {
                awsvpc_configuration: {
                  subnets: ['a_subnet'],
                  security_groups: ['a_security_group'],
                  assign_public_ip: 'ENABLED'
                }
              }
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

    context 'Aws::ECS::Service resource type' do
      it 'creates a service' do
        result = subject.call(default_params)

        expect(result.success).to include(
          service: include(
            logical_name: :my_service,
            arn: 'a_service_arn'
          )
        )
      end

      it 'service uses the cluster arn for the referenced logical cluster name' do
        expect_any_instance_of(Deploy::Commands::CreateService).to receive(:call).with(include(cluster: 'a_cluster_arn')).and_call_original

        subject.call(default_params)
      end

      it 'service uses the task definition arn for the referenced logical task definition name' do
        expect_any_instance_of(Deploy::Commands::CreateService).to receive(:call).with(include(task_definition: 'a_task_definition_arn')).and_call_original

        subject.call(default_params)
      end

      context 'when cluster reference DOES NOT exist as resource' do
        let(:params) do
          default_params.dup
        end

        it 'returns results with failure' do
          params[:resources][:my_service][:properties][:cluster][:ref] = 'invalid_cluster_reference'

          result = subject.call(params)

          expect(result.failure).to include(
            resources: include(
              my_service: include(
                properties: include(
                  cluster: include('logical name not found')
                )
              )
            )
          )
        end
      end

      context 'when task_definition reference DOES NOT exist as resource' do
        let(:params) do
          default_params.dup
        end

        it 'returns result with failure' do
          params[:resources][:my_service][:properties][:task_definition][:ref] = 'invalid_task_definition_reference'

          result = subject.call(params)

          expect(result.failure).to include(
            resources: include(
              my_service: include(
                properties: include(
                  task_definition: include('logical name not found')
                )
              )
            )
          )
        end
      end
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
      let(:params) do
        default_params.dup
      end

      it 'result returns an empty cluster' do
        params.fetch(:resources).delete(:my_cluster)
        params.fetch(:resources).delete(:my_service)

        result = subject.call(default_params)

        expect(result.success).to include(
          cluster: []
        )
      end
    end

    context 'when there are no task_definitions defined under resources' do
      let(:params) do
        default_params.dup
      end

      it 'result returns an empty task_definition' do
        params.fetch(:resources).delete(:my_task)
        params.fetch(:resources).delete(:my_service)

        result = subject.call(default_params.merge(params))

        expect(result.success).to include(
          task_definition: []
        )
      end
    end

    context 'when there are no services defined under resources' do
      let(:params) do
        default_params.dup
      end

      it 'result returns an empty service' do
        default_params.fetch(:resources).delete(:my_service)
        result = subject.call(default_params)

        expect(result.success).to include(
          service: []
        )
      end
    end
  end
end
