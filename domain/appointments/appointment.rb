require "domain/shared/entity"

module Carpanta
  module Domain
    module Appointments
      class Appointment < Shared::Entity
        attr_reader :starting_at, :duration, :customer_id, :offer_id
        SECONDS = 60
        DURATION_MINUTES = [30, 60, 90, 120].freeze

        def initialize(params = {})
          super(params[:id])
          @starting_at = params[:starting_at]
          @duration = params[:duration]
          @customer_id = params[:customer_id]
          @offer_id = params[:offer_id]
        end

        def ending_at
          starting_at + duration * SECONDS
        end
      end
    end
  end
end
