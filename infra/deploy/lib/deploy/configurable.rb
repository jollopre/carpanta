module Deploy
  module Configurable
    def configure
      @configuration ||= Configuration.new
      yield(@configuration)
    end

    def configuration
      @configuration
    end

    class Configuration
      attr_accessor :aws_access_key_id, :aws_secret_access_key, :region, :output, :cluster_name
    end
  end
end
