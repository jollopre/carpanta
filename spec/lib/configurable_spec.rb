require "lib/configurable"

RSpec.describe Configurable do
  let(:configurable) do
    Class.new do
      include Configurable
    end
  end

  before(:each) { configurable.instance_variable_set(:@configuration, nil) }

  describe ".configure" do
    it "yields configuration object" do
      expect do |b|
        configurable.configure(&b)
      end.to yield_with_args(Configurable::Configuration)
    end
  end

  describe ".configure_with" do
    it "creates a configuration object with the attributes passed" do
      expect(Configurable::Configuration).to receive(:new).with([:foo, :bar])

      configurable.configure_with :foo, :bar
    end
  end

  describe ".configuration" do
    it "returns a configuration object responding to the attributes passed" do
      configurable.configure_with :foo, :bar

      expect(configurable.configuration).to respond_to(:foo)
      expect(configurable.configuration).to respond_to(:bar)
      expect(configurable.configuration).to respond_to(:foo=)
      expect(configurable.configuration).to respond_to(:bar=)
    end
  end

  context "when a configurable class gets configured" do
    it "the configuration object readers return set values accordingly" do
      configurable.configure_with :foo, :bar

      configurable.configure do |config|
        config.foo = "foo"
        config.bar = "bar"
      end

      expect(configurable.configuration.foo).to eq("foo")
      expect(configurable.configuration.bar).to eq("bar")
    end
  end
end
