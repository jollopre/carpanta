require 'aws-sdk-ecs'
require 'yaml'
require_relative 'shared_context'

RSpec.describe 'rake deploy:up' do
  include_context 'rake setup'

  let(:task_name) { 'deploy:up' }
  let(:task_path) { 'tasks/up' }
  let(:up_instance) do
    instance_double(Deploy::Commands::Up)
  end
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
    file.write(params.to_yaml)
    file.rewind

    file.path
  end

  it 'initialises Commands::Up with an instance of Aws::ECS::Client' do
    allow(up_instance).to receive(:call)
    expect(Deploy::Commands::Up).to receive(:new).with(an_instance_of(Aws::ECS::Client)).and_return(up_instance)

    task.invoke(filepath)
  end

  it 'delegates into Commands::Up call with params defined in the YAML file' do
    allow(up_instance).to receive(:call)
    allow(Deploy::Commands::Up).to receive(:new).and_return(up_instance)

    task.invoke(filepath)

    expect(up_instance).to have_received(:call).with(params)
  end

  context 'when filepath argument is missing' do
    it 'raises error' do
      expect do
        task.invoke
      end.to raise_error('filepath is missing')
    end
  end

  context 'when path to YAML file does not exist' do
    it 'raises error' do
      expect do
        task.invoke('invalid_path')
      end.to raise_error('filepath not found')
    end
  end
end
