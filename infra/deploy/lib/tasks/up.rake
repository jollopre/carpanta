namespace :deploy do
  desc 'Provisions code into AWS ECS Fargate'
  task :up, [:filepath] do |t, args|
    require 'dry-monads'
    require 'dry/matcher/result_matcher'
    require 'aws-sdk-ecs'
    require 'json'
    require 'erb'
    require 'pathname'

    klass = Class.new do
      include Dry::Monads[:result]
      include Dry::Monads::Do.for(:call)

      def call(args)
        filepath = yield fetch_filepath(args)
        data = yield read(filepath)
        params = yield parse(data)

        client = Aws::ECS::Client.new
        up = Deploy::Commands::Up.new(client)

        up.call(params)
      end

      private

      def fetch_filepath(args)
        Success(args.fetch(:filepath))
      rescue KeyError
        Failure(details: ['filepath is missing'])
      end

      def parse(data)
        interpolated = ERB.new(data).result
        params = JSON.parse(interpolated, symbolize_names: true)
        Success(params)
      rescue JSON::ParserError
        Failure(details: ['malformed JSON'])
      end

      def read(filepath)
        return Failure(details: ['filepath not found']) unless Pathname.new(filepath).exist?

        Success(IO.read(filepath))
      end

      class << self
        def call(args = {})
          result = new.call(args)

          Dry::Matcher::ResultMatcher.call(result) do |m|
            m.success do |v|
              Deploy.logger.info(v.to_json)
            end
            m.failure do |v|
              Deploy.logger.error(v.to_json)
            end
          end
        end
      end
    end

    klass.call(args)
  end
end
