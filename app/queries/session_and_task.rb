require 'app/repositories/session'

module Carpanta
  module Queries
    class SessionAndTask
      def initialize(relation = Carpanta::Repositories::Session)
        @relation = relation
      end

      def call(ids)
        @relation.where(id: ids).includes(:task)
      end

      class << self
        def call(ids)
          new.call(ids)
        end
      end
    end
  end
end
