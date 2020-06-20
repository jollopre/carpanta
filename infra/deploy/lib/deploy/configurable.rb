module Deploy
  module Configurable
    def configure
      @configuration ||= Configuration.new
      yield(@configuration)
    end

    def configuration
      @configuration if defined?(@configuration)
    end

    def load_from_environment!
      configure do |config|
        config.cluster_name = fetch_env('CLUSTER_NAME')
      end
    end

    private

    def fetch_env(env_name)
      ENV.fetch(env_name) { raise EnvironmentVariableNotSet.new(env_name) }
    end

    class Configuration
      attr_accessor :cluster_name
    end
    class EnvironmentVariableNotSet < StandardError ; end
  end
end
