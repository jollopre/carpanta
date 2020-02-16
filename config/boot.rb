require 'bundler/setup'
Bundler.require(:default)

lambda do
  root_path = File.expand_path('..', File.dirname(__FILE__))
  $LOAD_PATH.unshift(root_path)
end.call

require 'app'
require 'app/routes'

Dir[File.expand_path(File.join(File.dirname(__FILE__), 'initializers', '**', '*.rb'))].each { |f| require f }
