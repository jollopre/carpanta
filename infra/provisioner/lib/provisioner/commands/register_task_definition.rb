require 'dry-monads'
require 'provisioner/schemas/register_task_definition'

module Provisioner
  module Commands
    class RegisterTaskDefinition
      include Dry::Monads[:result]

      def initialize(client)
        @client = client
        @schema = Schemas::RegisterTaskDefinition.new
      end

      def call(params)
        result = schema.call(params)
        return Failure(result.errors.to_h) if result.failure?

        response = client.register_task_definition({
          family: params[:family],
          container_definitions: params[:container_definitions].map do |definition|
            definition.merge(essential: true)
          end,
          execution_role_arn: params[:execution_role_arn],
          network_mode: 'awsvpc',
          requires_compatibilities: ['FARGATE'],
          cpu: params[:cpu],
          memory: params[:memory]
        })
        task_definition_arn = response.task_definition.task_definition_arn
        log_task_definition_created(task_definition_arn)
        
        Success(task_definition_arn)
      end

      private

      attr_reader :client, :schema

      def family
        Provisioner.configuration.family
      end

      def container_name
        Provisioner.configuration.container_name
      end

      def container_image
        Provisioner.configuration.container_image
      end

      def execution_role_arn
        Provisioner.configuration.execution_role_arn
      end

      def logger
        Provisioner.logger
      end

      def log_task_definition_created(arn)
        logger.info("Task definition created with arn: #{arn}")
      end
    end
  end
end
