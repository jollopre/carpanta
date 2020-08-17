RSpec.shared_context 'configuration' do
  let(:cluster_name) { 'a_cluster_name' }
  let(:family) { 'a_family' }
  let(:execution_role_arn) { 'an_execution_role_arn' }
  let(:container_name) { 'a_container_name' }
  let(:container_image) { 'a_container_image' }

  before(:each) do
    Provisioner.configure do |config|
      config.cluster_name = cluster_name
      config.family = family
      config.execution_role_arn = execution_role_arn
      config.container_name = container_name
      config.container_image = container_image
    end
  end

  after(:each) do
    Provisioner.instance_variable_set(:@configuration, nil)
  end
end
