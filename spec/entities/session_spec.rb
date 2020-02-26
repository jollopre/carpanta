require 'app/entities/session'

RSpec.describe Carpanta::Entities::Session do
  describe '.initialize' do
    it 'returns an instance responding to session attributes' do
      session = FactoryBot.build(:session)

      expect(session).to respond_to(:id)
      expect(session).to respond_to(:price)
      expect(session).to respond_to(:created_at)
      expect(session).to respond_to(:updated_at)
      expect(session).to respond_to(:customer_id)
      expect(session).to respond_to(:task_id)
    end
  end

  describe '.validates_presense_of' do
    context 'when price is not present' do
      it 'errors includes price' do
        session = FactoryBot.build(:session, price: nil)

        session.valid?

        expect(session.errors).to include(:price)
      end
    end

    context 'when customer_id is not present' do
      it 'errors include customer_id' do
        session = FactoryBot.build(:session)

        session.valid?

        expect(session.errors).to include(:customer_id)
      end
    end

    context 'when task_id is not present' do
      it 'errors include task_id' do
        session = FactoryBot.build(:session)

        session.valid?

        expect(session.errors).to include(:task_id)
      end
    end
  end

  describe '.validates_numericality_of' do
    context 'when price is not integer' do
      it 'errors includes price' do
        session = FactoryBot.build(:session, price: 'wadus')

        session.valid?

        expect(session.errors).to include(:price)
      end
    end

    context 'when customer_id is not integer' do
      it 'errors includes customer_id' do
        session = FactoryBot.build(:session, customer_id: 'wadus')

        session.valid?

        expect(session.errors).to include(:customer_id)
      end
    end

    context 'when task_id is not integer' do
      it 'errors includes task_id' do
        session = FactoryBot.build(:session, task_id: 'wadus')

        session.valid?

        expect(session.errors).to include(:task_id)
      end
    end
  end

  describe '#serializable_hash' do
    it 'returns a hash representing the model attributes' do
      session = FactoryBot.build(:session, price: 'wadus')

      result = session.serializable_hash

      expect(result).to include(:id, :price, :created_at, :updated_at, :customer_id, :task_id)
    end
  end
end
