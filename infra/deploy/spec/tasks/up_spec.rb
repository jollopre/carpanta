require_relative 'shared_context'

RSpec.describe 'rake deploy:up' do
  include_context 'rake setup'

  let(:task_name) { 'deploy:up' }
  let(:task_path) { 'tasks/up' }

  it 'provisions code into AWS ECS Fargate' do
    task.invoke

    skip
  end
end
