namespace :deploy do
  desc 'Provisions code into AWS ECS Fargate'
  task :up do
    require 'aws-sdk-ecs'
    Deploy.load_from_environment!
    client = Aws::ECS::Client.new
    Deploy::Commands::Up.new(client).call
  end
end
