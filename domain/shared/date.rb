require 'date'

module Domain
  module Shared
    module Date
      class << self
        def working_hours
          ['07:00', '08:00', '09:00', '10:00', '11:00', '12:00', '13:00', '14:00', '15:00', '16:00', '17:00', '18:00', '19:00', '20:00', '21:00', '22:00']
        end
      end
    end
  end
end
