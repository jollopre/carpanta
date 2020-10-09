require 'app/queries/offers_lookup'

RSpec.describe Carpanta::Queries::OffersLookup do
  let!(:offer) { FactoryBot.create(:offer) }

  describe '.call' do
    it 'returns success with offers' do
      result = described_class.call

      expect(result.success?).to eq(true)
      expect(result.value!).to include(
        have_attributes(
          id: offer.id,
          label: 'Cutting with scissor and Shampooing',
        )
      )
    end
  end
end
