require 'deploy/configurable'

RSpec.describe Deploy::Configurable do
  subject do
    Class.new do
      extend Deploy::Configurable
    end
  end

  describe '.load_from_environment!' do
    let!(:actual_env) { ENV.to_hash }

    before do
      ENV['AWS_ACCESS_KEY_ID'] = 'an_access_key'
      ENV['AWS_SECRET_ACCESS_KEY'] = 'a_secret'
      ENV['REGION'] = 'us-east-2'
      ENV['CLUSTER_NAME'] = 'a_cluster_name'
    end

    after do
      actual_env.map do |k,v|
        ENV[k] = v
      end
    end

    it 'sets a configuration object based on environment variables' do
      subject.load_from_environment!

      expect(subject.configuration.aws_access_key_id).to eq('an_access_key')
      expect(subject.configuration.aws_secret_access_key).to eq('a_secret')
      expect(subject.configuration.region).to eq('us-east-2')
      expect(subject.configuration.cluster_name).to eq('a_cluster_name')
    end

    context 'when any environment is not set' do
      RSpec.shared_examples 'raising EnvironmentVariableNotSet' do |env_name|
        before do
          ENV.delete(env_name)
        end

        it "raises EnvironmentVariableNotSet for #{env_name}" do
          expect do
            subject.load_from_environment!
          end.to raise_error(Deploy::Configurable::EnvironmentVariableNotSet, env_name)
        end
      end

      it_behaves_like 'raising EnvironmentVariableNotSet', 'AWS_ACCESS_KEY_ID'
      it_behaves_like 'raising EnvironmentVariableNotSet', 'AWS_SECRET_ACCESS_KEY'
      it_behaves_like 'raising EnvironmentVariableNotSet', 'REGION'
      it_behaves_like 'raising EnvironmentVariableNotSet', 'CLUSTER_NAME'
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
    it_behaves_like 'accessor for', :cluster_name
  end
end
