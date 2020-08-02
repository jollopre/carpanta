module Deploy
  module Configurable
    def configure
      @configuration ||= Configuration.new
      yield(@configuration)
    end

    def configuration
      @configuration if defined?(@configuration)
    end

    private

    class Configuration
      attr_accessor :cluster_name, :family, :execution_role_arn, :container_name, :container_image
    end
    class EnvironmentVariableNotSet < StandardError ; end
  end
end
