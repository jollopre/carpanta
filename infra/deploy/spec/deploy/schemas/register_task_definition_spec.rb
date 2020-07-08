require 'deploy/schemas/register_task_definition'
require_relative 'shared_examples'

RSpec.describe Deploy::Schemas::RegisterTaskDefinition do
  describe '#call' do
    subject { described_class.new }
    let(:default_params) do
      {
        family: 'a_family',
        execution_role_arn: 'a_execution_role_arn',
        cpu: '256',
        memory: '512',
        container_definitions: []
      }
    end

    it_behaves_like 'successful'

    context 'invalid' do
      context 'container_definitions' do
        let(:params) do
          { container_definitions: ['foo'] }
        end

        it 'must be an array of hashes with no missing keys' do
          result = subject.call(default_params.merge(params))

          expect(result.failure?).to eq(true)
          expect(result.errors.to_h).to include(
            container_definitions: include(
              0 => include(
                image: include('is missing'),
                name: include('is missing'),
              )
            )
          )
        end
      end

      context 'family' do
        it_behaves_like 'must be a string', { family: 1 }, :family
      end

      context 'execution_role_arn' do
        it_behaves_like 'must be a string', { execution_role_arn: 1 }, :execution_role_arn
      end

      context 'cpu' do
        it_behaves_like 'must be one of', { cpu: 'wadus' }, :cpu, ['256','512','1024','2048','4096']
      end

      context 'memory' do
        it_behaves_like 'must be one of', { memory: 'wadus' }, :memory, ['512', '1024', '2048', '3072', '4096', '5120', '6144', '7168', '8192', '9216', '10240', '11264', '12288', '13312', '14336', '15360', '16384', '17408', '18432', '19456', '20480', '21504', '22528', '23552', '24576', '25600', '26624', '27648', '28672', '29696', '30720']
      end

      context 'when cpu and memory keys are successfully processed' do
        context 'and cpu is 256' do
          it 'memory must be one of 512, 1024 or 2048' do
            result = subject.call(default_params.merge(cpu: '256', memory: '3072'))

            expect(result.failure?).to eq(true)
            expect(result.errors.to_h).to include(
              memory: include('must be one of: 512, 1024, 2048')
            )
          end
        end

        context 'and cpu is 512' do
          it 'memory must be one of 1024, 2048, 3072, 4096' do
            result = subject.call(default_params.merge(cpu: '512', memory: '512'))

            expect(result.failure?).to eq(true)
            expect(result.errors.to_h).to include(
              memory: include('must be one of: 1024, 2048, 3072, 4096')
            )
          end
        end

        context 'and cpu is 1024' do
          it 'memory must be one of 2048, 3072, 4096, 5120, 6144, 7168, 8192' do
            result = subject.call(default_params.merge(cpu: '1024', memory: '512'))

            expect(result.failure?).to eq(true)
            expect(result.errors.to_h).to include(
              memory: include('must be one of: 2048, 3072, 4096, 5120, 6144, 7168, 8192')
            )
          end
        end

        context 'and cpu is 2048' do
          it 'memory must be between 4096 and 16384 in increments of 1024' do
            result = subject.call(default_params.merge(cpu: '2048', memory: '512'))

            expect(result.failure?).to eq(true)
            expect(result.errors.to_h).to include(
              memory: include('must be one of: 4096, 5120, 6144, 7168, 8192, 9216, 10240, 11264, 12288, 13312, 14336, 15360, 16384')
            )
          end
        end

        context 'and cpu is 4096' do
          it 'memory must be between 8192 and 30720 in increments of 1024' do
            result = subject.call(default_params.merge(cpu: '4096', memory: '512'))

            expect(result.failure?).to eq(true)
            expect(result.errors.to_h).to include(
              memory: include('must be one of: 8192, 9216, 10240, 11264, 12288, 13312, 14336, 15360, 16384, 17408, 18432, 19456, 20480, 21504, 22528, 23552, 24576, 25600, 26624, 27648, 28672, 29696, 30720')
            )
          end
        end
      end
    end
  end
end

RSpec.describe Deploy::Schemas::RegisterTaskDefinition::ContainerDefinition do
  describe '#call' do
    subject { described_class.new }

    let(:default_params) do
      {
        image: 'an_image',
        name: 'a_name',
        port_mappings: []
      }
    end

    it_behaves_like 'successful'

    context 'invalid' do
      context 'image' do
        it_behaves_like 'must be a string', { image: 1 }, :image
      end

      context 'name' do
        it_behaves_like 'must be a string', { name: 1 }, :name
      end

      context 'port_mappings' do
        let(:params) do
          { port_mappings: ['foo'] }
        end

        it 'must be an array of hashes with no missing keys' do
          result = subject.call(default_params.merge(params))

          expect(result.failure?).to eq(true)
          expect(result.errors.to_h).to include(
            port_mappings: include(
              0 => include(
                container_port: include('is missing'),
              )
            )
          )
        end
      end

      context 'log_configuration' do
        let(:params) do
          { log_configuration: {} }
        end

        it 'must be a hash with no missing keys' do
          result = subject.call(default_params.merge(params))

          expect(result.failure?).to eq(true)
          expect(result.errors.to_h).to include(
            log_configuration: include(
              log_driver: include('is missing')
            )
          )
        end
      end
    end
  end
end

RSpec.describe Deploy::Schemas::RegisterTaskDefinition::ContainerDefinition::PortMapping do
  describe '#call' do
    subject { described_class.new }
    let(:default_params) do
      {
        container_port: 8080
      }
    end

    it_behaves_like 'successful'

    context 'invalid' do
      context 'container_port' do
        it_behaves_like 'must be an integer', { container_port: 'wadus' }, :container_port
      end
    end

    context 'protocol' do
      it_behaves_like 'must be one of', { protocol: 'wadus' }, :protocol, ['tcp', 'udp']
    end
  end
end

RSpec.describe Deploy::Schemas::RegisterTaskDefinition::ContainerDefinition::LogConfiguration do
  describe '#call' do
    subject { described_class.new }
    let(:default_params) do
      {
        log_driver: 'awslogs'
      }
    end

    it_behaves_like 'successful'

    context 'invalid' do
      context 'log_driver' do
        it_behaves_like 'must be one of', { log_driver: 'wadus' }, :log_driver, ['awslogs', 'splunk', 'awsfirelens']
      end

      context 'options' do
        it 'must be a hash' do
          skip
        end
      end
    end
  end
end
