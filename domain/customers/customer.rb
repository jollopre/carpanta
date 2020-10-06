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

        def to_h
          instance_variables.reduce({}) do |acc, var_name|
            key = var_name.to_s[1..-1].to_sym
            acc[key] = instance_variable_get(var_name)
            acc
          end
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
