require 'provisioner/configurable'

RSpec.describe Provisioner::Configurable do
  subject do
    Class.new do
      extend Provisioner::Configurable
    end
  end

  describe '.configure' do
    it 'yields a Configuration object' do
      expect do |b|
        subject.configure(&b)
      end.to yield_with_args(be_an_instance_of(Provisioner::Configurable::Configuration))
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

      expect(result).to be_an_instance_of(Provisioner::Configurable::Configuration)
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

  describe Provisioner::Configurable::Configuration do
    RSpec.shared_examples 'accessor for' do |attribute|
      subject { described_class.new }

      it "responds to #{attribute}" do
        expect(subject).to respond_to(attribute)
      end

      it "responds to #{attribute}=" do
        expect(subject).to respond_to("#{attribute}=")
      end
    end

    it_behaves_like 'accessor for', :cluster_name
    it_behaves_like 'accessor for', :family
    it_behaves_like 'accessor for', :execution_role_arn
    it_behaves_like 'accessor for', :container_name
    it_behaves_like 'accessor for', :container_image
  end
end
