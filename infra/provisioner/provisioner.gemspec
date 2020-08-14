require File.expand_path("../lib/provisioner/version", __FILE__)

Gem::Specification.new do |spec|
  spec.name          = 'provisioner'
  spec.version       = Provisioner::VERSION
  spec.authors       = ["Jose Lloret"]
  spec.email         = ["jollopre@gmail.com"]

  spec.summary       = %q{A gem to provision infrastructure resources to ECS Fargate}
  spec.description   = %q{.}
  spec.homepage      = "https://github.com/jollopre/carpanta/infra/provisioner"
  spec.license       = "MIT"

  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = ""

    spec.metadata["homepage_uri"] = spec.homepage
    spec.metadata["source_code_uri"] = "https://github.com/jollopre"
    spec.metadata["changelog_uri"] = "https://github.com/jollopre"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files = Dir.chdir(File.expand_path('..', __FILE__)) {}
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency 'bundler', '~> 2.1.2'
  spec.add_development_dependency 'rspec', '~> 3.9'
  spec.add_dependency 'aws-sdk-ecs', '~> 1.65'
  spec.add_dependency 'dry-validation', '~> 1.5', '>= 1.5.1'
  spec.add_dependency 'dry-monads', '~> 1.3', '>= 1.3.5'
  spec.add_dependency 'dry-matcher', '~> 0.8.3'
  spec.add_dependency 'rake', '~> 13.0', '>= 13.0.1'
end
