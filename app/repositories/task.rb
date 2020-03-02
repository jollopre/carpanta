require 'active_record'
require_relative 'repository'

module Carpanta
  module Repositories
    class Task < ActiveRecord::Base
      extend Repository
    end
  end
end
