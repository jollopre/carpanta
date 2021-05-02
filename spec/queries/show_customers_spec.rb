require "app/queries/show_customers"

RSpec.describe Carpanta::Queries::ShowCustomers do
  let!(:customer) { FactoryBot.create(:customer) }

  describe ".call" do
    it "returns success with customers" do
      result = described_class.call

      customers = result.value!
      expect(customers).to include(
        have_attributes(
          name: customer.name,
          surname: customer.surname,
          email: customer.email,
          phone: customer.phone
        )
      )
    end
  end
end
