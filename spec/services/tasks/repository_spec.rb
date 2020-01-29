require 'app/services/tasks/repository'

RSpec.describe Carpanta::Services::Tasks::Repository do
  let(:storage) { Carpanta::Services::Tasks::Repository::Storage }
  let(:task) { build(:task) }
  let(:persisted_task) { build(:task, :persisted) }

  describe '.create' do
    it 'returns a persisted task' do
      class_double(storage, create: persisted_task).as_stubbed_const

      result = described_class.create(task)

      expect(result.id).not_to be_nil
      expect(result.created_at).not_to be_nil
      expect(result.updated_at).not_to be_nil
    end

    context 'when the task cannot be persisted' do
      let(:task_with_errors) { build(:task, with_errors: true) }

      it 'returns a task with errors' do
        class_double(storage, create: task_with_errors).as_stubbed_const

        result = described_class.create(task)

        expect(result.errors).not_to be_empty
      end
    end
  end
end
