require 'domain/offers/repository'
require 'domain/offers/offer'
require 'domain/offers/errors'

RSpec.describe Carpanta::Domain::Offers::Repository do
  let(:offer) do
    FactoryBot.build(:offer)
  end
  let(:not_found_class) do
    Carpanta::Domain::Offers::Errors::NotFound
  end

  describe '.create!' do
    it 'inserts an offer into its repository' do
      result = described_class.create!(offer)

      expect(result.id).not_to be_nil
      expect(result.created_at).not_to be_nil
      expect(result.updated_at).not_to be_nil
      expect(result).to be_an_instance_of(Carpanta::Domain::Offers::Offer)
    end
  end

  describe '.find_by_id!' do
    it 'returns an offer instance' do
      persisted_offer = described_class.create!(offer)

      result = described_class.find_by_id!(persisted_offer.id)

      expect(result).to eq(persisted_offer)
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
