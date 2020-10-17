require 'domain/shared/entity'

module Carpanta
  module Domain
    module Customers
      class Customer < Shared::Entity
        attr_reader :name, :surname, :email, :phone

        def initialize(params = {})
          super(params[:id])
          @name = params[:name]
          @surname = params[:surname]
          @email = params[:email]
          @phone = params[:phone]
        end
      end
    end
  end
end
