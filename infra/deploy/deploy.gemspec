lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'deploy/version'

Gem::Specification.new do |spec|
  spec.name          = 'deploy'
  spec.version       = Deploy::VERSION
  spec.authors       = ["Jose Lloret"]
  spec.email         = ["jollopre@gmail.com"]

  spec.summary       = %q{A gem to deploy to ECS}
  spec.description   = %q{.}
  spec.homepage      = "https://github.com/jollopre"
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

  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency 'bundler', '~> 2.1.2'
  spec.add_development_dependency 'rspec', '~> 3.9'
  spec.add_dependency 'aws-sdk-ecs', '~> 1.65'
  spec.add_dependency 'dry-schema', '~> 1.5', '>= 1.5.2'
  spec.add_dependency 'rake', '~> 13.0', '>= 13.0.1'
end
