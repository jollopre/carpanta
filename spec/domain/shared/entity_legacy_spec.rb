require 'domain/shared/entity_legacy'

RSpec.describe Carpanta::Domain::Shared::EntityLegacy do
  describe '.new' do
    it 'creates an entity' do
      entity = described_class.new

      expect(entity.id).to match(/[0-9a-fA-F]{8}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{12}/)
    end
  end

  describe '#==' do
    let(:entity) do
      described_class.new
    end

    it 'returns true' do
      another_entity = described_class.new
      another_entity.id = entity.id

      result = entity == another_entity

      expect(result).to eq(true)
    end

    context 'when the object passed is not a class of Entity' do
      it 'returns false' do
        result = entity == nil

        expect(result).to eq(false)
      end
    end
  end

  describe '#attributes' do
    let(:entity) do
      described_class.new
    end

    it 'raises RuntimeError' do
      expect do
        entity.attributes
      end.to raise_error(RuntimeError, /Not implemented/)
    end
  end
end
