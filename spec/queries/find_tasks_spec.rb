require 'app/queries/find_tasks'

RSpec.describe Carpanta::Queries::FindTasks do
  let!(:task) { FactoryBot.create(:task) }

  describe '.call' do
    it 'gets all the tasks' do
      result = described_class.call

      expect(result).to include(have_attributes(name: task.name, description: task.description, price: task.price))
    end
  end

  context 'when params are sent' do
    let(:task) { FactoryBot.create(:task) }
    let!(:another_task) { FactoryBot.create(:task) }

    context 'with id' do
      let(:params) { { id: [task.id] } }

      it 'filters by id' do
        result = described_class.call(params)

        expect(result).to include(have_attributes(id: task.id))
        expect(result.size).to eq(1)
      end
    end
  end
end
