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
        config.aws_access_key_id = fetch_env('AWS_ACCESS_KEY_ID')
        config.aws_secret_access_key = fetch_env('AWS_SECRET_ACCESS_KEY')
        config.region = fetch_env('REGION')
        config.cluster_name = fetch_env('CLUSTER_NAME')
      end
    end

    private

    def fetch_env(env_name)
      ENV.fetch(env_name) { raise EnvironmentVariableNotSet.new(env_name) }
    end

    class Configuration
      attr_accessor :aws_access_key_id, :aws_secret_access_key, :region, :output, :cluster_name
    end
    class EnvironmentVariableNotSet < StandardError ; end
  end
end
