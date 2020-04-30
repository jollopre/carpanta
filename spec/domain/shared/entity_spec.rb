require 'domain/shared/entity'

RSpec.describe Carpanta::Domain::Shared::Entity do
  describe '.new' do
    it 'creates an entity' do
      entity = described_class.new(id: 1, created_at: Time.now, updated_at: Time.now)

      expect(entity.id).to eq(1)
      expect(entity.created_at).to be_an_instance_of(Time)
      expect(entity.created_at).to be_an_instance_of(Time)
    end
  end

  describe '#==' do
    let(:entity) do
      described_class.new(id: 1, created_at: Time.now, updated_at: Time.now)
    end

    it 'returns true' do
      another_entity = described_class.new(id: entity.id, created_at: entity.created_at, updated_at: entity.updated_at)

      result = entity == another_entity

      expect(result).to eq(true)
    end

    context 'when the object passed does not respond to attributes' do
      it 'returns false' do
        result = entity == nil

        expect(result).to eq(false)
      end
    end

    context 'when any of its attributes is different' do
      it 'returns false' do
        another_entity = described_class.new(id: 2)

        result = entity == another_entity

        expect(result).to eq(false)
      end
    end
  end
end
