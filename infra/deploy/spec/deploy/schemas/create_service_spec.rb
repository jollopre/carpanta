require 'deploy/schemas/create_service'
require_relative 'shared_examples'

RSpec.describe Deploy::Schemas::CreateService do
  describe '#call' do
    subject { described_class.new }
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

    it_behaves_like 'successful'

    context 'invalid' do
      context 'cluster' do
        it_behaves_like 'must be a string', { cluster: 1 }, :cluster
      end

      context 'service_name' do
        it_behaves_like 'must be a string', { service_name: 1 }, :service_name
      end

      context 'task_definition' do
        it_behaves_like 'must be a string', { task_definition: 1 }, :task_definition
      end

      context 'desired_count' do
        it_behaves_like 'must be an integer', { desired_count: 'foo' }, :desired_count

        it 'must be greater than zero' do
          result = subject.call(default_params.merge(desired_count: 0))

          expect(result.errors.to_h).to include(
            desired_count: include('must be greater than 0')
          )
        end
      end

      context 'network_configuration' do
        it_behaves_like 'must be a hash', { network_configuration: 'foo' }, :network_configuration

        context 'awsvpc_configuration' do
          it 'must be a hash' do
            params = default_params.merge(network_configuration: { awsvpc_configuration: 'foo' })

            result = subject.call(default_params.merge(params))

            expect(result.errors.to_h).to include(
              network_configuration: include(
                awsvpc_configuration: include('must be a hash')
              )
            )
          end

          context 'subnets' do
            it 'must be an array' do
              params = default_params.merge(
                network_configuration: {
                  awsvpc_configuration: {
                    subnets: 'foo'
                  }
                }
              )

              result = subject.call(default_params.merge(params))

              expect(result.errors.to_h).to include(
                network_configuration: include(
                  awsvpc_configuration: include(
                    subnets: include('must be an array')
                  )
                )
              )
            end

            it 'must be an array of string' do
              params = default_params.merge(
                network_configuration: {
                  awsvpc_configuration: {
                    subnets: ['foo', 1]
                  }
                }
              )

              result = subject.call(default_params.merge(params))

              expect(result.errors.to_h).to include(
                network_configuration: include(
                  awsvpc_configuration: include(
                    subnets: include(
                      1 => include('must be a string')
                    )
                  )
                )
              )
            end
          end

          context 'security_groups' do
            it 'must be an array' do
              params = default_params.merge(
                network_configuration: {
                  awsvpc_configuration: {
                    security_groups: 'foo'
                  }
                }
              )

              result = subject.call(default_params.merge(params))

              expect(result.errors.to_h).to include(
                network_configuration: include(
                  awsvpc_configuration: include(
                    security_groups: include('must be an array')
                  )
                )
              )
            end

            it 'must be an array of string' do
              params = default_params.merge(
                network_configuration: {
                  awsvpc_configuration: {
                    security_groups: ['foo', 1]
                  }
                }
              )

              result = subject.call(default_params.merge(params))

              expect(result.errors.to_h).to include(
                network_configuration: include(
                  awsvpc_configuration: include(
                    security_groups: include(
                      1 => include('must be a string')
                    )
                  )
                )
              )
            end
          end

          context 'assign_public_ip' do
            it 'must be one of' do
              params = {
                network_configuration: {
                  awsvpc_configuration: {
                    assign_public_ip: 'wadus'
                  }
                }
              }

              result = subject.call(default_params.merge(params))

              expect(result.errors.to_h).to include(
                network_configuration: include(
                  awsvpc_configuration: include(
                    assign_public_ip: include('must be one of: ENABLED, DISABLED')
                  )
                )
              )
            end
          end
        end
      end
    end
  end
end
