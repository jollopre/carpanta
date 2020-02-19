require 'active_record'

module Carpanta
  module Storage
    class Task < ActiveRecord::Base ; end
    class Session < ActiveRecord::Base ; end
    class Customer < ActiveRecord::Base
      validates_uniqueness_of :email
    end
  end
end
