namespace :deploy do
  desc 'Provisions code into AWS ECS Fargate'
  task :up, [:filepath] do |t, args|
    require 'aws-sdk-ecs'
    require 'yaml'
    require 'pathname'

    klass = Class.new do
      class << self
        def call(filepath)
          params = read_from(filepath)
          client = Aws::ECS::Client.new
          up = Deploy::Commands::Up.new(client)

          up.call(params)
        end

        private

        def read_from(filepath)
          interpolated = interpolate(filepath)
          YAML.load(interpolated)
        end

        def interpolate(filepath)
          ERB.new(read(filepath)).result
        end

        def read(filepath)
          raise 'filepath not found' unless Pathname.new(filepath).exist?
          IO.read(filepath)
        end
      end
    end

    begin
      filepath = args.fetch(:filepath)
      klass.call(filepath)
    rescue KeyError
      raise 'filepath is missing'
    end
  end
end
