require 'app/services/tasks'
require 'app/entities/task'
require 'spec/services/shared_context'

RSpec.describe Carpanta::Services::Tasks do
  include_context 'services errors'

  describe '.create!' do
    let(:attributes) do
      FactoryBot.attributes_for(:task)
    end
    let(:entity) do
      Carpanta::Entities::Task
    end
    let(:repository) do
      described_class.configuration.repository
    end

    it 'forwards into its repository with a task' do
      class_double(repository).as_stubbed_const

      expect(repository).to receive(:create!) do |task|
        expect(task.name).to eq('Dyeing Hair')
        expect(task.description).to eq('Dyeing Hair consist of ...')
        expect(task.price).to eq(1500)
      end

      described_class.create!(attributes)
    end

    context 'when task attributes are invalid' do
      it 'raises RecordInvalid' do
        attributes.merge!(name: nil)

        expect do
          described_class.create!(attributes)
        end.to raise_error(record_invalid, /Name can't be blank/)
      end
    end
  end
end
