require 'active_record'
require 'yaml'

lambda do
  database_tasks = ActiveRecord::Tasks::DatabaseTasks
  database_tasks.env = ENV.fetch('RACK_ENV')
  database_tasks.database_configuration = YAML.load(ERB.new(IO.read('config/database.yml')).result)
  database_tasks.db_dir = 'db'
  database_tasks.migrations_paths = 'db/migrate'
  #database_tasks.seed_loader = nil
  database_tasks.root = ENV.fetch('ROOT_PATH')

  #https://guides.rubyonrails.org/configuring.html#configuring-active-record
  config = ActiveRecord::Base
  config.logger = Logger.new(STDOUT)

  # Establish connection needed for tasks such as (migrate or drop)
  ActiveRecord::Base.establish_connection(YAML.load(ERB.new(IO.read('config/database.yml')).result)['development'])
end.call
