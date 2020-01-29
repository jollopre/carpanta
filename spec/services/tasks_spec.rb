require 'app/services/tasks'
require 'app/services/tasks/model'
require 'spec/services/shared_context'

RSpec.describe Carpanta::Services::Tasks do
  include_context 'services errors'
  let(:task_class) { Carpanta::Services::Tasks::Model }

  describe '.create!' do
    let(:attributes) do
      FactoryBot.attributes_for(:task)
    end

    it 'returns a task without errors' do
      result = described_class.create!(attributes)

      expect(result).to be_an_instance_of(task_class)
      expect(result.id).not_to be_nil
      expect(result.errors).to be_empty
    end

    context 'when the attributes received instantiate an invalid task' do
      it 'raises RecordInvalid' do
        attributes.merge!(name: nil)

        expect do
          described_class.create!(attributes)
        end.to raise_error(record_invalid, /Name can't be blank/)
      end
    end

    context 'when there is an error persisting the task' do
      it 'raises RecordInvalid'
    end
  end
end
