require 'dry-monads'
require 'dry/monads/do'
require 'deploy/schemas/up'
require 'deploy/commands/create_cluster'

module Deploy
  module Commands
    class Up
      include Dry::Monads[:result]
      include Dry::Monads::Do.for(:call)

      def initialize(client)
        @client = client
        @schema = Schemas::Up.new
      end

      def call(params = {})
        yield validate(params)
      end

      private

      attr_reader :client, :schema

      def validate(params)
        result = schema.call(params)
        return Failure(result.errors.to_h) if result.failure?

        Success(result.values)
      end
    end
  end
end
