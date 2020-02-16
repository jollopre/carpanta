require 'app/services/tasks'
require 'spec/services/shared_context'

RSpec.describe Carpanta::Services::Tasks do
  include_context 'services errors'

  describe '.create!' do
    let(:attributes) do
      FactoryBot.attributes_for(:task)
    end

    it 'persists a task' do
      result = described_class.create!(attributes)

      expect(result).to eq(true)
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
