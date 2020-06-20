require 'deploy/version'
require 'deploy/configurable'
require 'deploy/loggable'
require 'deploy/commands/up'

module Deploy
  extend Configurable
  extend Loggable
end
