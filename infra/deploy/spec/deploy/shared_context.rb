RSpec.shared_context 'configuration' do
  let(:cluster_name) { 'a_cluster_name' }

  before(:each) do
    Deploy.configure do |config|
      config.cluster_name = cluster_name
    end
  end

  after(:each) do
    Deploy.instance_variable_set(:@configuration, nil)
  end
end
