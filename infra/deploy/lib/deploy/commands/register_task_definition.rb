module Deploy
  module Commands
    class RegisterTaskDefinition
      def initialize(client)
        @client = client
      end

      def call
        response = client.register_task_definition({
          family: family,
          container_definitions: [{
            name: container_name,
            image: container_image
          }],
          execution_role_arn: execution_role_arn,
          network_mode: 'awsvpc',
          requires_compatibilities: ['FARGATE'],
          cpu: '256',
          memory: '512'
        })
        task_definition_arn = response.task_definition.task_definition_arn
        log_task_definition_created(task_definition_arn)
        
        task_definition_arn
      end

      private

      attr_reader :client

      def family
        Deploy.configuration.family
      end

      def container_name
        Deploy.configuration.container_name
      end

      def container_image
        Deploy.configuration.container_image
      end

      def execution_role_arn
        Deploy.configuration.execution_role_arn
      end

      def logger
        Deploy.logger
      end

      def log_task_definition_created(arn)
        logger.info("Task definition created with arn: #{arn}")
      end
    end
  end
end
