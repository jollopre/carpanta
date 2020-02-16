require 'app/services/sessions'
require 'spec/services/shared_context'

RSpec.describe Carpanta::Services::Sessions do
  include_context 'services errors'

  describe '.create!' do
    let(:attributes) do
      FactoryBot.attributes_for(:session, customer_id: 1, task_id: 1)
    end

    it 'persists a session' do
      result = described_class.create!(attributes)

      expect(result).to eq(true)
    end

    context 'when the session attributes are invalid' do
      it 'raises RecordInvalid' do
        attributes.merge!(price: nil)

        expect do
          described_class.create!(attributes)
        end.to raise_error(record_invalid, /Price can't be blank/)
      end
    end
  end
end
