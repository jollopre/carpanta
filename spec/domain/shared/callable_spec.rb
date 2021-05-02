require "domain/shared/callable"

RSpec.describe Carpanta::Domain::Shared::Callable do
  let(:klass) do
    Class.new do
      extend Carpanta::Domain::Shared::Callable

      def call(*args)
        yield if block_given?
      end
    end
  end

  describe ".call" do
    let(:klass_instance) { klass.new }

    before do
      allow(klass).to receive(:new).and_return(klass_instance)
    end

    it "invokes instance method call" do
      allow(klass_instance).to receive(:call).and_call_original

      klass.call(1, {foo: "bar"}, bar: "baz")

      expect(klass_instance).to have_received(:call).with(1, {foo: "bar"}, {bar: "baz"})
    end

    context "when block is passed" do
      it "yields control" do
        expect do |b|
          klass.call(1, &b)
        end.to yield_control
      end
    end

    context "when no arguments are passed" do
      it "invokes instance method call with no arguments" do
        allow(klass_instance).to receive(:call)

        klass.call

        expect(klass_instance).to have_received(:call).with(no_args)
      end
    end

    context "when the extended class only accepts an argument" do
      let(:klass) do
        Class.new do
          extend Carpanta::Domain::Shared::Callable

          def call(args)
            yield if block_given?
          end
        end
      end

      it "invokes instance method class with only one argument" do
        allow(klass_instance).to receive(:call)

        klass.call(1)

        expect(klass_instance).to have_received(:call).with(1)
      end
    end
  end
end
