require "domain/offers/offer"

RSpec.describe Carpanta::Domain::Offers::Offer do
  describe "#to_h" do
    let(:attributes) do
      {
        tasks: ["Cutting with scissor", "Shampooing"],
        price: 2200
      }
    end

    subject do
      described_class.new(attributes)
    end

    it "returns a hash with the attributes from offer" do
      result = subject.to_h

      expect(result).to include(
        id: anything,
        tasks: ["Cutting with scissor", "Shampooing"],
        price: 2200
      )
    end
  end
end
