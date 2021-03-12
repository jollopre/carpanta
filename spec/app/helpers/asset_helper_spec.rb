require 'app/helpers/asset_helper'

RSpec.describe Carpanta::Helpers::AssetHelper do
  describe '.javascript_tag' do
    it 'returns script html tag' do
      skip
      result = described_class.javascript_tag('index')

      expect(result).to eq('<script src="/assets/index.8ebd4c2390a579d09587.js"></script>')
    end

    context 'when the source does not exist' do
      it 'raises AssetNotFound error' do
        skip
        expect do
          described_class.javascript_tag('non_existent_source')
        end.to raise_error(described_class::AssetNotFound)
      end
    end
  end
end
