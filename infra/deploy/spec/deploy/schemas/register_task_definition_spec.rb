require 'deploy/schemas/register_task_definition'

RSpec.describe Deploy::Schemas::RegisterTaskDefinition do
  RSpec.shared_examples 'must be a string' do |params, key|
    context "when `#{params[key]}` is received" do
      it 'result failed' do
        result = described_class.call(default_params.merge(params))

        expect(result.failure?).to eq(true)
      end

      it 'errors include message' do
        result = described_class.call(default_params.merge(params))

        expect(result.errors.to_h).to include(
          key => include('must be a string')
        )
      end
    end
  end

  RSpec.shared_examples 'must be filled' do |params, key|
    context "when `#{params[key]}` is received" do
      it 'result failed' do
        result = described_class.call(default_params.merge(params))

        expect(result.failure?).to eq(true)
      end

      it 'errors include message' do
        result = described_class.call(default_params.merge(params))

        expect(result.errors.to_h).to include(
          key => include('must be filled')
        )
      end
    end
  end

  describe '.call' do
    let(:default_params) do
      {
        family: 'a_family',
        execution_role_arn: 'a_execution_role_arn',
        cpu: '256',
        memory: '512'
      }
    end

    context 'valid' do
      it 'does not contain errors' do
        result = described_class.call(default_params)

        expect(result.success?).to eq(true)
      end
    end

    context 'invalid' do
      context 'family' do
        it_behaves_like 'must be a string', { family: 1 }, :family
        it_behaves_like 'must be a string', { family: 1.1 }, :family
        it_behaves_like 'must be filled', { family: nil }, :family
        it_behaves_like 'must be filled', { family: [] }, :family
        it_behaves_like 'must be filled', { family: {} }, :family
      end

      context 'execution_role_arn' do
        it_behaves_like 'must be a string', { execution_role_arn: 1 }, :execution_role_arn
        it_behaves_like 'must be a string', { execution_role_arn: 1.1 }, :execution_role_arn
        it_behaves_like 'must be filled', { execution_role_arn: nil }, :execution_role_arn
        it_behaves_like 'must be filled', { execution_role_arn: [] }, :execution_role_arn
        it_behaves_like 'must be filled', { execution_role_arn: {} }, :execution_role_arn
      end

      context 'cpu' do
        it_behaves_like 'must be a string', { cpu: 1 }, :cpu
        it_behaves_like 'must be a string', { cpu: 1.1 }, :cpu
        it_behaves_like 'must be filled', { cpu: nil }, :cpu
        it_behaves_like 'must be filled', { cpu: [] }, :cpu
        it_behaves_like 'must be filled', { cpu: {} }, :cpu

        it 'must be one of CPU enum' do
          result = described_class.call(default_params.merge(cpu: 'wadus'))

          expect(result.failure?).to eq(true)
          expect(result.errors.to_h).to include(
            cpu: include('must be one of: 256, 512, 1024, 2048, 4096')
          )
        end
      end

      context 'memory' do
        it_behaves_like 'must be a string', { memory: 1 }, :memory
        it_behaves_like 'must be a string', { memory: 1.1 }, :memory
        it_behaves_like 'must be filled', { memory: nil }, :memory
        it_behaves_like 'must be filled', { memory: [] }, :memory
        it_behaves_like 'must be filled', { memory: {} }, :memory

        it 'must be one of memory enum' do
          result = described_class.call(default_params.merge(memory: 'wadus'))

          expect(result.failure?).to eq(true)
          expect(result.errors.to_h).to include(
            memory: include('must be one of: 512, 1024, 2048, 3072, 4096, 5120, 6144, 7168, 8192, 9216, 10240, 11264, 12288, 13312, 14336, 15360, 16384, 17408, 18432, 19456, 20480, 21504, 22528, 23552, 24576, 25600, 26624, 27648, 28672, 29696, 30720')
          )
        end
      end
    end
  end
end
