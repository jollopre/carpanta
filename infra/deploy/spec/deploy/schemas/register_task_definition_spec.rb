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
        execution_role_arn: 'a_execution_role_arn'
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
        it 'uses an enum' do
          skip ('https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definition_parameters.html#task_size')
        end
      end
    end
  end
end
