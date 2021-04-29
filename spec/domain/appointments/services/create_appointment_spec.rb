require "domain/appointments/services/create_appointment"

RSpec.describe Carpanta::Domain::Appointments::Services::CreateAppointment do
  describe ".call" do
    let(:default_attributes) do
      {
        starting_at: Time.new(2020, 10, 18, 11, 11, 11),
        customer_id: "TODO",
        offer_id: "TODO",
        duration: 60
      }
    end

    context "when the attributes are invalid" do
      let(:attributes) do
        default_attributes.merge(starting_at: "foo")
      end

      it "returns failure" do
        result = described_class.call(attributes)

        expect(result.failure).to include(
          starting_at: include("must be a time")
        )
      end
    end

    context "when there is already an appointment set up" do
      before do
        FactoryBot.create(:appointment, default_attributes)
      end

      let(:attributes) do
        default_attributes.merge(duration: 30)
      end

      it "returns failure" do
        result = described_class.call(attributes)

        expect(result.failure).to include(
          duration: include("must not overlap with another existing starting_at + duration (min)")
        )
      end
    end

    context "when the customer_id does not exist"

    context "when the offer_id does not exist"

    it "returns the id created" do
      result = described_class.call(default_attributes)

      expect(result.value!).to match(/[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}/)
      skip("check appointment is persisted")
    end
  end
end
