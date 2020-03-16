RSpec.describe Carpanta do
  describe '.development?' do
    context 'when environment is development' do
      it 'returns true' do
        allow(described_class.configuration).to receive(:environment).and_return('development')

        result = described_class.development?

        expect(result).to eq(true)
      end
    end

    context 'when the environment is test' do
      it 'returns true' do
        allow(described_class.configuration).to receive(:environment).and_return('test')

        result = described_class.development?

        expect(result).to eq(true)
      end
    end

    context 'when environment is not development or test' do
      it 'returns false' do
        allow(described_class.configuration).to receive(:environment).and_return('production')

        result = described_class.development?

        expect(result).to eq(false)
      end
    end
  end
end
