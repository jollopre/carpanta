require 'domain/appointments/repository_legacy'

RSpec.describe Carpanta::Domain::Appointments::RepositoryLegacy do
  let(:appointment) do
    FactoryBot.build(:appointment)
  end

  describe '.save!' do
    it 'returns true' do
      result = described_class.save!(appointment)

      expect(result).to eq(true)
    end
  end

  describe '.find_all' do
    before do
      described_class.save!(appointment)
    end

    it 'returns appointments' do
      result = described_class.find_all

      expect(result).to include(appointment)
    end
  end
end
