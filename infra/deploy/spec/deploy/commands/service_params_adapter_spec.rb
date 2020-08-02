require 'deploy/commands/service_params_adapter'

RSpec.describe Deploy::Commands::ServiceParamsAdapter do
  describe '#call' do
    let(:params) do
      {
        cluster: { ref: 'a_cluster_name' },
        task_definition: { ref: 'a_task_definition_name' }
      }
    end

    let(:cluster_pairs) do
      [
        { logical_name: 'a_cluster_name', arn: 'a_cluster_arn' }
      ]
    end

    let(:task_definition_pairs) do
      [
        { logical_name: 'a_task_definition_name', arn: 'a_task_definition_arn' }
      ]
    end

    subject do
      described_class.new(params: params, cluster_pairs: cluster_pairs, task_definition_pairs: task_definition_pairs)
    end

    it 'result success includes the arn for cluster' do
      result = subject.call

      expect(result.success).to include(
        cluster: 'a_cluster_arn'
      )
    end

    it 'result success includes the arn for task_definition' do
      result = subject.call

      expect(result.success).to include(
        task_definition: 'a_task_definition_arn'
      )
    end

    context 'when ref does not have a pair associated' do
      let(:cluster_pairs) { [] }
      let(:task_definition_pairs) { [] }

      it 'result failure includes cluster error' do
        result = subject.call

        expect(result.failure).to include(
          cluster: 'logical name not found'
        )
      end

      it 'result failure includes task_definition error' do
        result = subject.call

        expect(result.failure).to include(
          task_definition: 'logical name not found'
        )
      end
    end

    context 'when there are no refs' do
      let(:params) do
        {
          cluster: 'a_cluster_name' ,
          task_definition: 'a_task_definition_name'
        }
      end

      it 'no replacements are produced' do
        result = subject.call

        expect(result.success).to eq(params)
      end
    end
  end
end
