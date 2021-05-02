require "domain/appointments/validations/on_create"
require "spec/domain/shared/shared_examples"

RSpec.describe Carpanta::Domain::Appointments::Validations::OnCreate do
  describe "#call" do
    let(:default_params) do
      {
        duration: 50,
        starting_at: "2020-10-15T08:03:12Z",
        customer_id: "f901d3bf-9d71-4ef9-9848-bd1634fceb7e",
        offer_id: "63a74e85-c41b-49fa-8936-ab64a62b1b8a"
      }
    end

    it_behaves_like "successful"

    context "invalid" do
      context "duration" do
        it_behaves_like "must be an integer", {duration: "foo"}, :duration

        it "must be greater than 0" do
          params = default_params.merge(duration: 0)

          result = subject.call(params)

          expect(result.errors.to_h).to include(
            duration: include("must be greater than 0")
          )
        end
      end

      context "starting_at" do
        it "must be a time" do
          params = default_params.merge(starting_at: "foo")

          result = subject.call(params)

          expect(result.errors.to_h).to include(
            starting_at: include("must be a time")
          )
        end
      end

      context "customer_id" do
        it_behaves_like "must be a string", {customer_id: ["foo"]}, :customer_id
      end

      context "offer_id" do
        it_behaves_like "must be a string", {offer_id: ["foo"]}, :offer_id
      end
    end
  end
end
