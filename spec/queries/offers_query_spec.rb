require 'app/queries/offers_query'

RSpec.describe Carpanta::Queries::OffersQuery do
  let!(:offer) { FactoryBot.create(:offer) }
  subject { described_class.new }

  describe '#to_a' do
    it 'returns a collection of offers' do
      result = subject.to_a

      expect(result).to include(
        have_attributes(
          id: offer.id,
          name: 'Cutting with scissor and Shampooing',
          price: 2200
        )
      )
    end
  end
end
