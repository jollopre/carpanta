require "domain/shared/validation"

RSpec.describe Carpanta::Domain::Shared::Validation do
  let(:klass) do
    Class.new(Carpanta::Domain::Shared::Validation) do
      params do
        required(:foo).filled(:string)
      end
    end
  end

  describe ".call" do
    let(:default_args) do
      {foo: "bar"}
    end

    it "returns valid data processed" do
      result = klass.call(default_args)

      expect(result.success?).to eq(true)
      expect(result.success).to eq({foo: "bar"})
    end

    context "when data is invalid" do
      it "returns failures" do
        args = default_args.merge(foo: 1)

        result = klass.call(args)

        expect(result.failure?).to eq(true)
        expect(result.failure).to include(
          foo: include("must be a string")
        )
      end
    end
  end
end
