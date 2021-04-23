require 'lib/sinatra/asset_helper'

RSpec.describe Sinatra::AssetHelper do
  subject do
    class Aclass
      extend Sinatra::AssetHelper
    end
  end

  describe '.javascript_tag' do
    let(:data) do
      {
        "index.js": "/assets/index.8ebd4c2390a579d09587.js"
      }.to_json
    end

    it 'returns script html tag' do
      allow(File).to receive(:read).with(/manifest.json/).and_return(data)

      result = subject.javascript_tag('index')

      expect(result).to eq('<script src="/assets/index.8ebd4c2390a579d09587.js"></script>')
    end

    context 'when the source does not exist' do
      it 'raises AssetNotFound error' do
        expect do
          subject.javascript_tag('non_existent_source')
        end.to raise_error(Sinatra::AssetHelper::AssetNotFound)
      end
    end
  end

  describe '.stylesheet_tag' do
    let(:data) do
      {
        "foo.css": "/assets/foo.d69e9fd4eebbebaca750.css"
      }.to_json
    end

    it 'returns link html tag' do
      allow(File).to receive(:read).with(/manifest.json/).and_return(data)

      result = subject.stylesheet_tag('foo')

      expect(result).to eq('<link rel="stylesheet" href="/assets/foo.d69e9fd4eebbebaca750.css"></link>')
    end

    context 'when the source does not exist' do
      it 'raises AssetNotFound error' do
        expect do
          subject.stylesheet_tag('non_existent_source')
        end.to raise_error(Sinatra::AssetHelper::AssetNotFound)
      end
    end
  end
end
