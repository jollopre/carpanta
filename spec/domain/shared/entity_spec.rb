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
end
