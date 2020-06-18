RSpec.shared_context 'rake setup' do
  require 'rake'

  let(:task_name) {}
  let(:task_path) {}
  subject(:task) { Rake::Task[task_name] }

  before do
    Rake.application.rake_require(task_path)
  end

  after do
    task.reenable
  end
end
