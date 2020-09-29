require 'securerandom'

module Domain
  module Shared
    module Identifiable
      class << self
        def generate
          SecureRandom.uuid
        end
      end

      def id
        @id ||= Identifiable.generate
      end

      def ==(other)
        return false unless other.respond_to?(:id)

        id == other.id
      end
    end
  end
end
