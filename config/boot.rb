require 'rubygems'
require 'bundler/setup'
Bundler.require(:default)

lambda do
  root_path = File.expand_path('..', File.dirname(__FILE__))
  $LOAD_PATH.unshift(root_path)
end.call

require 'app/controllers/application'

Dir[File.expand_path(File.join(File.dirname(__FILE__), 'initializers', '**', '*.rb'))].each { |f| require f }
