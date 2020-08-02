require 'aws-sdk-ecs'
require 'yaml'
require_relative 'shared_context'

RSpec.describe 'rake deploy:up' do
  include_context 'rake setup'

  let(:task_name) { 'deploy:up' }
  let(:task_path) { 'tasks/up' }
  let(:params) do
    {
      resources: {
        my_cluster: {
          type: 'Aws::ECS::Cluster',
          properties: {
            cluster_name: 'a_cluster_name'
          }
        }
      }
    }
  end
  let(:filepath) do
    file = Tempfile.new
    file.write(params.to_json)
    file.rewind

    file.path
  end
  let!(:client) do
    Aws::ECS::Client.new(stub_responses: true)
  end
  let!(:up_instance) do
    Deploy::Commands::Up.new(client)
  end

  before do
    allow(Aws::ECS::Client).to receive(:new).and_return(client)
    allow(Deploy::Commands::Up).to receive(:new).and_return(up_instance)
  end

  it 'delegates into Commands::Up call with params defined in the JSON file' do
    allow(up_instance).to receive(:call).and_call_original

    task.invoke(filepath)

    expect(up_instance).to have_received(:call).with(params)
  end

  it 'logs the cluster, task_definition and service created' do
    allow(Deploy.logger).to receive(:info)

    task.invoke(filepath)

    result = {
      cluster: [{ logical_name: :my_cluster, arn: 'String' }],
      task_definition: [],
      service: []
    }.to_json
    expect(Deploy.logger).to have_received(:info).with(result)
  end

  context 'when params defined in the JSON file are not valid' do
    let(:params) do
      { foo: 'bar' }
    end

    it 'logs errors' do
      allow(Deploy.logger).to receive(:error)

      task.invoke(filepath)

      result = {
        resources: ['is missing']
      }.to_json
      expect(Deploy.logger).to have_received(:error).with(result)
    end
  end

  context 'when filepath argument is missing' do
    it 'logs error' do
      expect(Deploy.logger).to receive(:error).with(/filepath is missing/)

      task.invoke
    end
  end

  context 'when path to JSON file does not exist' do
    it 'logs error' do
      expect(Deploy.logger).to receive(:error).with(/filepath not found/)

      task.invoke('invalid_path')
    end
  end

  context 'when file is not JSON formatted' do
    let(:filepath) do
      file = Tempfile.new
      file.write('malformed_json_file')
      file.rewind

      file.path
    end

    it 'logs error' do
      expect(Deploy.logger).to receive(:error).with(/malformed JSON/)

      task.invoke(filepath)
    end
  end
end
