require 'provisioner/schemas/up'
require_relative 'shared_examples'

RSpec.describe Provisioner::Schemas::Up do
  describe '#call' do
    subject { described_class.new }
    let(:cluster) do
      {
        cluster_name: 'a_cluster_name'
      }
    end
    let(:task_definition) do
      {
        family: 'a_family',
        execution_role_arn: 'a_execution_role_arn',
        cpu: '256',
        memory: '512',
        container_definitions: []
      }
    end
    let(:service) do
      {
        cluster_name: { ref: 'my_cluster' },
        service_name: 'a_service_name',
        task_definition: { ref: 'my_task' },
        desired_count: 1,
        network_configuration: {
          awsvpc_configuration: {
            subnets: [],
            security_groups: [],
            assign_public_ip: 'ENABLED'
          }
        }
      }
    end
    let(:default_params) do
      {
        resources: {
          my_cluster: {
            type: 'Aws::ECS::Cluster',
            properties: cluster
          },
          my_task: {
            type: 'Aws::ECS::TaskDefinition',
            properties: task_definition,
          },
          my_service: {
            type: 'Aws::ECS::Service',
            properties: service
          }
        }
      }
    end

    it_behaves_like 'successful'

    context 'invalid' do
      context 'resources' do
        it_behaves_like 'must be a hash', { resources: 'foo' }, :resources

        context 'when any value is not a resource' do
          let(:resources) do
            {
              :my_cluster => 'foo'
            }
          end

          it 'errors include type is missing' do
            result = subject.call(default_params.merge(resources: resources))

            expect(result.errors.to_h).to include(
              resources: include(
                :my_cluster => include(
                  type: include('is missing')
                )
              )
            )
          end
        end
      end
    end
  end
end

RSpec.describe Provisioner::Schemas::Up::Resource do
  describe '#call' do
    subject { described_class.new }

    let(:default_params) do
      {
        type: 'Aws::ECS::Cluster',
        properties: {
          cluster_name: 'a_cluster_name'
        }
      }
    end

    it_behaves_like 'successful'

    context 'invalid' do
      context 'type' do
        it_behaves_like 'must be one of', { type: 'foo'}, :type, ['Aws::ECS::Cluster', 'Aws::ECS::TaskDefinition', 'Aws::ECS::Service']
      end

      context 'properties' do
        context 'when type is Aws::ECS::Cluster' do
          it 'Provisioner::Schemas::CreateCluster is expected' do
            params = { properties: { cluster_name: 1 }}

            result = subject.call(default_params.merge(params))

            expect(result.errors.to_h).to include(
              properties: include(
                cluster_name: include('must be a string')
              )
            )
          end
        end

        context 'when type is Aws::ECS::TaskDefinition' do
          it 'Provisioner::Schemas::RegisterTaskDefinition is expected' do
            params = { type: 'Aws::ECS::TaskDefinition', properties: { family: 'a_family', execution_role_arn: 'a_execution_role_arn', cpu: 'foo', memory: 'bar', container_definitions: [] }}

            result = subject.call(default_params.merge(params))

            expect(result.errors.to_h).to include(
              properties: include(
                cpu: include(/must be one of:/),
                memory: include(/must be one of:/)
              )
            )
          end
        end

        context 'when type is Aws::ECS::Service' do
          it 'Provisioner::Schemas::CreateService is expected' do
            params = { type: 'Aws::ECS::Service', properties: { cluster_name: 'a_cluster_name', service_name: 1234, task_definition: 'a_task_definition', desired_count: 1, network_configuration: { awsvpc_configuration: { subnets: [], security_groups: [], assign_public_ip: 'ENABLED '}}}}

            result = subject.call(params)

            expect(result.errors.to_h).to include(
              properties: include(
                service_name: include('must be a string')
              )
            )
          end
        end
      end
    end
  end
end
