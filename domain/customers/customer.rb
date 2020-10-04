module Carpanta
  module Domain
    module Customers
      class Entity
        require 'securerandom'
        attr_reader :id

        def initialize(id = nil)
          @id = id || SecureRandom.uuid
        end

        def ==(other)
          return false unless other.respond_to?(:id)

          id == other.id
        end
      end

      class Customer < Entity
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
