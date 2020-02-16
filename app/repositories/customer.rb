module Carpanta
  module Repositories
    class Customer < ActiveRecord::Base
      validates_uniqueness_of :email
    end
  end
end
