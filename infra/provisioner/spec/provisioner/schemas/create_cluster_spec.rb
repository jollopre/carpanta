require 'provisioner/schemas/create_cluster'
require_relative 'shared_examples'

RSpec.describe Provisioner::Schemas::CreateCluster do
  describe '#call' do
    subject { described_class.new }
    let(:default_params) do
      {
        cluster_name: 'a_cluster_name'
      }
    end

    it_behaves_like 'successful'

    context 'invalid' do
      context 'create_cluster' do
        it_behaves_like 'must be a string', { cluster_name: 1 }, :cluster_name
      end
    end
  end
end
