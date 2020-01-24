require 'bundler/setup'
Bundler.require(:default)

lambda do
  root_path = File.expand_path('..', File.dirname(__FILE__))
  $LOAD_PATH.unshift(root_path)
end.call

require 'app'
require 'app/routes'
