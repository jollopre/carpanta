require 'rspec/core/rake_task'

namespace :test do
  desc 'Executes all the spec files'
  task :all => ["db:prepare"] do
    RSpec::Core::RakeTask.new(:spec).run_task(true)
  end
end
