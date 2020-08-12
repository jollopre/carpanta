require 'provisioner/version'
require 'provisioner/configurable'
require 'provisioner/loggable'
require 'provisioner/commands/up'

module Provisioner
  extend Configurable
  extend Loggable
end
