require 'securerandom'
require_relative 'custom_validators'

module Carpanta
  module Domain
    module Shared
      class Entity
        include ActiveModel::Model
        include ActiveModel::Serialization
        extend Shared::CustomValidators

        attr_accessor :id

        def initialize
          @id = SecureRandom.uuid
        end

        def attributes
          raise 'Not implemented'
        end

        def ==(entity)
          return false unless entity.is_a?(Entity)

          id == entity.id
        end
      end
    end
  end
end
