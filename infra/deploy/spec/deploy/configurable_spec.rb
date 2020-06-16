require 'deploy/configurable'

RSpec.describe Deploy::Configurable do
  subject do
    Class.new do
      extend Deploy::Configurable
    end
  end

  describe '.configure' do
    it 'yields a Configuration object' do
      expect do |b|
        subject.configure(&b)
      end.to yield_with_args(be_an_instance_of(Deploy::Configurable::Configuration))
    end
  end

  describe '.configuration' do
    context 'when is not set' do
      it 'returns nil' do
        result = subject.configuration

        expect(result).to be_nil
      end
    end

    it 'returns a Configuration object' do
      subject.configure { }

      result = subject.configuration

      expect(result).to be_an_instance_of(Deploy::Configurable::Configuration)
    end

    context 'when configured' do
      it 'the Configuration object is memoized' do
        subject.configure {}
        first_result = subject.configuration
        subject.configure {}
        second_result = subject.configuration

        expect(first_result).to eq(second_result)
      end
    end
  end

  describe Deploy::Configurable::Configuration do
    RSpec.shared_examples 'accessor for' do |attribute|
      subject { described_class.new }

      it "responds to #{attribute}" do
        expect(subject).to respond_to(attribute)
      end

      it "responds to #{attribute}=" do
        expect(subject).to respond_to("#{attribute}=")
      end
    end

    it_behaves_like 'accessor for', :aws_access_key_id
    it_behaves_like 'accessor for', :aws_secret_access_key
    it_behaves_like 'accessor for', :region
    it_behaves_like 'accessor for', :output
  end
end
