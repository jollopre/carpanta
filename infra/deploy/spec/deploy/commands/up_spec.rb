require 'aws-sdk-ecs'
require 'deploy/commands/up'
require 'deploy/commands/create_cluster'

RSpec.describe Deploy::Commands::Up do
  let(:client) do
    Aws::ECS::Client.new(stub_responses: true)
  end
  
  subject do
    described_class.new(client)
  end

  describe '#call' do
    let(:create_cluster) { instance_double(Deploy::Commands::CreateCluster) }

    before do
      allow(Deploy::Commands::CreateCluster).to receive(:new).with(client).and_return(create_cluster)
    end

    it 'creates a cluster' do
      expect(create_cluster).to receive(:call)

      subject.call
    end
  end
end
