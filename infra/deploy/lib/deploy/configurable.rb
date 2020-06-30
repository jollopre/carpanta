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
        config.family = fetch_env('FAMILY')
        config.execution_role_arn = fetch_env('EXECUTION_ROLE_ARN')
        config.container_name = fetch_env('CONTAINER_NAME')
        config.container_image = fetch_env('CONTAINER_IMAGE')
      end
    end

    private

    def fetch_env(env_name)
      ENV.fetch(env_name) { raise EnvironmentVariableNotSet.new(env_name) }
    end

    class Configuration
      attr_accessor :cluster_name, :family, :execution_role_arn, :container_name, :container_image
    end
    class EnvironmentVariableNotSet < StandardError ; end
  end
end
