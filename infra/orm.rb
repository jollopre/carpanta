module  Infra
  module ORM
    class Customer < ActiveRecord::Base
      has_many :appointments
    end
    class Offer < ActiveRecord::Base
      serialize :tasks, JSON
    end
    class Appointment < ActiveRecord::Base
      belongs_to :offer
    end
  end
end

