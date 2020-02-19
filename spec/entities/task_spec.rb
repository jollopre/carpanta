require 'app/entities/task'

RSpec.describe Carpanta::Entities::Task do
  describe '.initialize' do
    it 'returns an instance responding to task attributes' do
      task = FactoryBot.build(:task)

      expect(task).to respond_to(:id)
      expect(task.name).to eq('Dyeing Hair')
      expect(task.description).to eq('Dyeing Hair consist of ...')
      expect(task.price).to eq(1500)
      expect(task).to respond_to(:created_at)
      expect(task).to respond_to(:updated_at)
    end

    describe '.validates_presence_of' do
      context 'when name is not present' do
        it 'validates presence of name' do
          task = FactoryBot.build(:task, name: nil)

          expect(task.valid?).to eq(false)
        end

        it 'errors includes name' do
          task = FactoryBot.build(:task, name: nil)

          task.valid?

          expect(task.errors).to include(:name)
        end
      end

      context 'when price is not present' do
        it 'validates presence of price' do
          task = FactoryBot.build(:task, price: nil)

          expect(task.valid?).to eq(false)
        end

        it 'errors includes price' do
          task = FactoryBot.build(:task, price: nil)

          task.valid?

          expect(task.errors).to include(:price)
        end
      end

      it 'returns true otherwise' do
        task = FactoryBot.build(:task)

        expect(task.valid?).to eq(true)
      end
    end

    describe '.validates_numericality_of' do
      context 'when price is not an integer' do
        it 'returns invalid for price as String' do
          task = FactoryBot.build(:task, price: 'wadus')

          expect(task.valid?).to eq(false)
        end

        it 'returns invalid for price as Float' do
          task = FactoryBot.build(:task, price: 15.00)

          expect(task.valid?).to eq(false)
        end

        it 'errors includes price' do
          task = FactoryBot.build(:task, price: 'wadus')

          task.valid?

          expect(task.errors).to include(:price)
        end
      end
    end

    describe '#serializable_hash' do
      it 'returns a hash representing the model attributes' do
        task = FactoryBot.build(:task, price: 'wadus')

        result = task.serializable_hash

        expect(result).to include(:id, :name, :price, :created_at, :updated_at)
      end
    end
  end
end
