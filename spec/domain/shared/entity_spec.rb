require "domain/shared/entity"

RSpec.describe Carpanta::Domain::Shared::Entity do
  describe "#to_h" do
    subject { described_class.new }

    it "returns a hash with the attributes from customer" do
      result = subject.to_h

      expect(result).to include(
        id: match(/[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}/)
      )
    end
  end

  describe "#==" do
    it "returns true" do
      other = described_class.new(subject.id)

      result = subject == other

      expect(result).to eq(true)
    end

    context "when other does not respond to id" do
      it "returns false" do
        other = nil

        result = subject == other

        expect(result).to eq(false)
      end
    end

    context "when ids are different" do
      it "returns false" do
        other = described_class.new

        result = subject == other

        expect(result).to eq(false)
      end
    end
  end
end
