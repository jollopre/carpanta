require 'app/services/sessions'
require 'app/entities/session'
require 'spec/services/shared_context'

RSpec.describe Carpanta::Services::Sessions do
  include_context 'services errors'

  describe '.create!' do
    let(:attributes) do
      FactoryBot.attributes_for(:session, customer_id: 1, task_id: 1)
    end
    let(:entity) do
      Carpanta::Entities::Session
    end
    let(:repository) do
      described_class.configuration.repository
    end

    it 'forwards into its repository with a session' do
      class_double(repository).as_stubbed_const

      expect(repository).to receive(:create!) do |session|
        expect(session.price).to eq(1500)
        expect(session.customer_id).to eq(1)
        expect(session.task_id).to eq(1)
      end

      described_class.create!(attributes)
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
