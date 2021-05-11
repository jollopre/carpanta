require "app/queries/customers_lookup"

RSpec.describe Carpanta::Queries::CustomersLookup do
  let!(:customer) { FactoryBot.create(:customer) }

  describe ".call" do
    it "returns success with customers" do
      result = described_class.call

      expect(result.success?).to eq(true)
      expect(result.value!).to include(
        have_attributes(
          id: customer.id,
          label: "#{customer.surname}, #{customer.name}"
        )
      )
    end
  end
end
