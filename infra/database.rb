require "yaml"
require "lib/configurable"

module Infra
  class Database
    include Singleton
    include Configurable

    configure_with :root, :environment, :logger

    PATH = "config/database.yml".freeze
    DB_DIR = "db".freeze
    MIGRATIONS_PATHS = "#{DB_DIR}/migrate".freeze

    def connect!
      ActiveRecord::Base.configurations = configurations
      ActiveRecord::Base.logger = logger
      task_class.create_current(environment)
    end

    private

    def initialize
      task_class.env = environment
      task_class.database_configuration = configurations
      task_class.db_dir = DB_DIR
      task_class.migrations_paths = MIGRATIONS_PATHS
      task_class.seed_loader = SeedLoader.new
      task_class.root = root
    end

    def configurations
      YAML.safe_load(ERB.new(IO.read(PATH)).result)
    end

    def environment
      self.class.configuration.environment
    end

    def root
      self.class.configuration.root
    end

    def logger
      self.class.configuration.logger
    end

    def task_class
      ActiveRecord::Tasks::DatabaseTasks
    end

    class << self
      def connect!
        instance.connect!
      end

      def load_tasks
        load "active_record/railties/databases.rake"
        Rake::Task.define_task(:environment)
      end
    end

    class SeedLoader
      def load_seed
        load "#{Database::DB_DIR}/seed.rb"
      end
    end
  end
end
