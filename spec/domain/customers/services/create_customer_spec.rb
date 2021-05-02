require "domain/customers/services/create_customer"

RSpec.describe Carpanta::Domain::Customers::Services::CreateCustomer do
  describe ".call" do
    let(:default_attributes) do
      {
        name: "Donald",
        surname: "Duck",
        email: "donald.duck@carpanta.com"
      }
    end

    context "when the attributes are invalid" do
      let(:attributes) do
        default_attributes.merge(email: "donald@")
      end

      it "returns failure" do
        result = described_class.call(attributes)

        expect(result.failure).to include(
          email: include("is in invalid format")
        )
      end
    end

    context "when the email is not unique" do
      before do
        FactoryBot.create(:customer, default_attributes)
      end

      it "returns failure" do
        result = described_class.call(default_attributes)

        expect(result.failure).to include(
          email: include("is not unique")
        )
      end
    end

    it "returns the id created" do
      result = described_class.call(default_attributes)

      expect(result.value!).to match(/[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}/)
      skip("check customer is persisted")
    end
  end
end
