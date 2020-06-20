require 'aws-sdk-ecs'
require_relative 'shared_context'

RSpec.describe 'rake deploy:up' do
  include_context 'rake setup'

  let(:task_name) { 'deploy:up' }
  let(:task_path) { 'tasks/up' }
  let(:up_instance) do
    instance_double(Deploy::Commands::Up)
  end
  let!(:current_env) { ENV.to_h }
  before do
    allow(Deploy::Commands::Up).to receive(:new).with(an_instance_of(Aws::ECS::Client)).and_return(up_instance)
    ENV['CLUSTER_NAME'] = 'a_cluster_name'
  end
  after do
    current_env.each do |k,v|
      ENV[k] = v
    end
  end

  it 'provisions code into AWS ECS Fargate' do
    expect(up_instance).to receive(:call)

    task.invoke
  end
end
