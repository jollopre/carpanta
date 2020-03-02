require 'active_record'
require_relative 'repository'

module Carpanta
  module Repositories
    class Session < ActiveRecord::Base
      extend Repository
      belongs_to :task
    end
  end
end
