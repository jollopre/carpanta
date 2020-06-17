RSpec.shared_context 'configuration' do
  let(:cluster_name) { 'a_cluster_name' }

  before(:each) do
    Deploy.configure do |config|
      config.aws_access_key_id = 'an_access_key'
      config.aws_secret_access_key = 'a_secret'
      config.region = 'us-east-2'
      config.output = 'json'
      config.cluster_name = cluster_name
    end
  end

  after(:each) do
    Deploy.instance_variable_set(:@configuration, nil)
  end
end
