require 'domain/offers/repository_legacy'
require 'domain/offers/errors'

RSpec.describe Carpanta::Domain::Offers::RepositoryLegacy do
  let(:offer) do
    FactoryBot.build(:offer_legacy)
  end
  let(:not_found_class) do
    Carpanta::Domain::Offers::Errors::NotFound
  end

  describe '.save!' do
    it 'returns true' do
      result = described_class.save!(offer)

      expect(result).to eq(true)
    end
  end

  describe '.find_by_id!' do
    it 'returns an offer instance' do
      described_class.save!(offer)

      result = described_class.find_by_id!(offer.id)

      expect(result).to eq(offer)
    end

    context 'when there is no offer for the id' do
      it 'raises NotFound' do
        expect do
          described_class.find_by_id!('non_existent')
        end.to raise_error(not_found_class)
      end
    end
  end
end
