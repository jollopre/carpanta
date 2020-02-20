require 'active_record'
require_relative 'repository'

module Carpanta
  module Repositories
    class Customer < ActiveRecord::Base
      extend Repository

      validates_uniqueness_of :email
    end
  end
end
