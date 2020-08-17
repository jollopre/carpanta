require 'dry-monads'
require 'provisioner/schemas/create_service'

module Provisioner
  module Commands
    class CreateService
      SCHEDULING_STRATEGY = 'REPLICA'.freeze
      LAUNCH_TYPE = 'FARGATE'.freeze

      include Dry::Monads[:result]

      def initialize(client)
        @client = client
        @schema = Schemas::CreateService.new
      end

      def call(params)
        result = schema.call(params)
        return Failure(result.errors.to_h) if result.failure?

        values = result.values
        response = client.create_service(values.merge(
          scheduling_strategy: SCHEDULING_STRATEGY,
          launch_type: LAUNCH_TYPE
        ))
        service_arn = response.service.service_arn
        log_service_created(service_arn)

        Success(service_arn)
      end

      private

      attr_reader :client, :schema

      def logger
        Provisioner.logger
      end

      def log_service_created(arn)
        logger.info("Service created with arn: #{arn}")
      end
    end
  end
end
